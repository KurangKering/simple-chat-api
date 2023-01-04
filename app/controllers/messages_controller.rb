class MessagesController < ApplicationController
  # show all friends within the conversations of current user
  def list_conversations
    is_success, message, data = MessageRepository.list_conversations(@current_user[:id_user], request.GET)
    render json: [success: is_success, message:, data:]
  end

  # show all messages from current user and recipent user ordered by date created desc
  def show
    is_success, message, data = MessageRepository.show_messages(@current_user[:id_user], params[:id_user], request.GET)
    render json: [success: is_success, message:, data:]
  end

  # send message to a friend
  def create
    validator = BodyValidator::MessageCreateValidator.new(request.POST)
    return render json: { success: false, message: 'Validation error', data: validator.errors.messages } unless validator.valid?

    is_friend = FriendshipRepository.find(@current_user[:id_user], request.POST[:id_recipient])
    return render json: { success: false, message: 'You are not friends', data: {} } unless is_friend.any?

    is_success, message, data = MessageRepository.send(@current_user[:id_user], request.POST)
    render json: [success: is_success, message:, data:]
  end

  # mark a message as read
  def mark_as_read
    params[:id_message]
    is_success, message, data = MessageRepository.mark_as_read(@current_user[:id_user], params[:id_message])
    render json: [success: is_success, message:, data:]
  end
end
