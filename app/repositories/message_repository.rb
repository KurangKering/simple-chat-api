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

  def show_messages(current_user, dest_user, opt= {})
      opt[:page] = opt[:page] || 1
      opt[:items] = opt[:items] || 10
      opt[:search] = opt[:search] || nil
      messages = Message.from("messages m")
      messages = messages.where(["m.id_sender = :curr OR mr.id_recipient = :curr", {curr: current_user}])
      messages = messages.where(["m.id_sender = :dest OR mr.id_recipient = :dest", {dest: dest_user}])
      messages = messages.where("m.message LIKE ?", "%" + opt[:search] + "%") unless !opt[:search] || opt[:search].strip.empty?
      messages = messages.joins("JOIN message_recipients mr ON m.id_message = mr.id_message")
      messages = messages.select("m.id_message, m.id_sender", "mr.id_recipient", "m.message", "m.type message_type", "mr.is_read", "m.created_at")
      messages = messages.order('m.created_at': :desc)

      @pagy, @records = pagy(messages, page: opt[:page], items: opt[:items])
      data = { page: @pagy.page, next_page: @pagy.next, total_data: @pagy.count, per_page: @pagy.items, messages: @records }

      [true, 'messages retrieved', data]
  end

end