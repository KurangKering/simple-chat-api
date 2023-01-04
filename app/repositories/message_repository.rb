module MessageRepository
  extend self
  include Pagy::Backend
  def list_conversations(id_user, opt = {})
    opt[:page] = opt[:page] || 1
    opt[:items] = opt[:items] || 10
    opt[:search] = opt[:search] || nil
    sql = <<~SQL
      SELECT
      rec.id_user,
      rec.name,
      m.message,
      m.type message_type,
      rec.image,
      m.created_at,
      COUNT(tmp_mr.id_message) count_unread
      FROM messages m JOIN
      message_recipients mr ON m.id_message = mr.id_message
      JOIN users AS rec ON (if(mr.id_recipient = :id_user, m.id_sender = rec.id_user, mr.id_recipient = rec.id_user)  )
      JOIN (SELECT tmp_mr.id_message, tmp_mr.is_read FROM message_recipients tmp_mr) tmp_mr
      ON tmp_mr.id_message = mr.id_message
      WHERE m.id_sender = :id_user OR mr.id_recipient = :id_user
      GROUP BY rec.id_user
      ORDER BY m.created_at DESC
    SQL
    sanitized = ActiveRecord::Base.sanitize_sql([sql, { id_user: }])
    relation = Message.select('*').from("(#{sanitized}) AS t")
    @pagy, @records = pagy(relation, page: opt[:page], items: opt[:items])
    data = { page: @pagy.page, next_page: @pagy.next, total_data: @pagy.count, per_page: @pagy.items, list: @records.as_json(except: [:id_message]) }
    [true, 'list conversations retrieved', data]
  end

  def show_messages(current_user, dest_user, opt = {})
    opt[:page] = opt[:page] || 1
    opt[:items] = opt[:items] || 10
    opt[:search] = opt[:search] || nil
    messages = Message.from("messages m")
    messages = messages.where(["m.id_sender = :curr OR mr.id_recipient = :curr", { curr: current_user }])
    messages = messages.where(["m.id_sender = :dest OR mr.id_recipient = :dest", { dest: dest_user }])
    messages = messages.where("m.message LIKE ?", "%" + opt[:search] + "%") unless !opt[:search] || opt[:search].strip.empty?
    messages = messages.joins("JOIN message_recipients mr ON m.id_message = mr.id_message")
    messages = messages.select("m.id_message, m.id_sender", "mr.id_recipient", "m.message", "m.type message_type", "mr.is_read", "m.created_at")
    messages = messages.order('m.created_at': :desc)
    @pagy, @records = pagy(messages, page: opt[:page], items: opt[:items])
    data = { page: @pagy.page, next_page: @pagy.next, total_data: @pagy.count, per_page: @pagy.items, messages: @records }
    [true, 'messages retrieved', data]
  end

  def send(current_user, post)
    success = false
    message = ''
    itype = ImageRepository.input_type(post[:message])
    return [success, 'File type not allowed', {}] unless itype

    msg =  post[:message]
    if itype == 'image'
      path_img = ImageRepository.insert_image(msg)
      return [success, 'Image failed uploaded', {}] unless path_img

      msg = path_img
    end
    id_message = nil
    nmessage = nil
    mr = nil
    ActiveRecord::Base.transaction do
      nmessage = Message.new
      nmessage.id_sender = current_user
      nmessage.type = itype
      nmessage.message = msg
      if nmessage.save
        id_message = nmessage.id_message
        mr = MessageRecipient.new
        mr.id_message = id_message
        mr.id_recipient = post[:id_recipient]
        mr.is_read = 0
        if mr.save
          success = true
          message = 'Message sent'
        end
      end
    rescue StandardError => e
      message = e
    end
    if success
      [success, message, { id_message:, id_sender: nmessage.id_sender, id_recipient: mr.id_recipient, message: nmessage.message, type: nmessage.type }]
    else
      [false, 'Sending message failed', {}]
    end
  end

  def mark_as_read(current_user, id_message)
    msg = Message.from("messages m")
    msg = msg.where(["mr.id_recipient = :curr AND m.id_message = :id_message", { curr: current_user, id_message: }])
    msg = msg.joins("JOIN message_recipients mr ON m.id_message = mr.id_message")
    msg = msg.select("m.id_message", "mr.read_at", "m.id_sender", "mr.id_recipient", "m.message", "m.type as message_type", "mr.is_read", "m.created_at")
    msg = msg.limit(1)
    return [false, 'Message not found', {}] unless msg.any?
    return [false, 'Message already read', {}] if msg[0].is_read == 1

    msg = MessageRecipient.where(id_message: id_message, id_recipient: current_user).first
    umsg = msg.update(is_read: 1, read_at: DateTime.now )
    if umsg
      [true, 'Success mark message as read', msg.reload]
    else
      [false, 'Failed mark message as read', {}]
    end
  end
end
