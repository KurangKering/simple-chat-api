class MessagesController < ApplicationController
  require './app/repositories/friendship_repository'
  
  # show all friends within the conversations of current user
  def list_conversations
    is_success, message, data = MessageRepository.list_conversations(@current_user[:id_user], request.GET)
    render json: [success: is_success, message:, data: data]
  end

  # show all messages from current user and recipent user ordered by date created desc
  def show
    is_success, message, data = MessageRepository.show_messages(@current_user[:id_user], params[:id_user], request.GET)
    render json: [success: is_success, message:, data: data]
  end

end
