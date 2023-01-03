class UsersController < ApplicationController
  require './app/repositories/user_repository'

  def index
    users = UserRepository.list_users(@current_user[:id_user], request.GET)
    render json: [success: true, message: 'Users retrieved', data: users]
  end

  def show; end
end
