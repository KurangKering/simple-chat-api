class FriendshipsController < ApplicationController
  require './app/repositories/friendship_repository'

  def index
    friendships = FriendshipRepository.list_friends(@current_user[:id_user], request.GET)
    render json: [success: true, message: 'Friends retrieved', data: friendships]
  end

  def show
    id_friend = params[:id]
    return show_pending if id_friend == 'pending'

    pending = FriendshipRepository.find(@current_user[:id_user], id_friend)
    if pending.any?
      render json: [success: true, message: 'Friend retrieved', data: pending]
    else
      render json: [success: false, message: 'Friend not found', data: {}]
    end
  end

  def show_pending
    friendships = FriendshipRepository.list_pending(@current_user[:id_user], request.GET)
    render json: [success: true, message: 'Pending Friends retrieved', data: friendships]
  end

  # add friend request
  def create
    validator = BodyValidator::FriendshipCreateValidator.new(request.POST)

    return render json: { success: false, message: 'Validation error', data: validator.errors.messages } unless validator.valid?

    is_success, message = FriendshipRepository.add(@current_user[:id_user], request.POST[:id_user])
    render json: [success: is_success, message:, data: {}]
  end

  # accept friend request
  def update
    is_success, message = FriendshipRepository.accept(@current_user[:id_user], params[:id])
    render json: [success: is_success, message:, data: {}]
  end

  # reject friend request or remove friend
  def reject
    is_success, message = FriendshipRepository.reject(@current_user[:id_user], params[:id])
    render json: [success: is_success, message:, data: {}]
  end

  def remove
    is_success, message = FriendshipRepository.remove(@current_user[:id_user], params[:id])
    render json: [success: is_success, message:, data: {}]
  end
end
