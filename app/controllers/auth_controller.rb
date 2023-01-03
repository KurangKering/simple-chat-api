class AuthController < ApplicationController
  skip_before_action :authenticate_request

  include BodyValidator
  include BCrypt
  def login
    validator = BodyValidator::LoginValidator.new(params.permit(:email, :password))
    unless validator.valid?
      return render json: { success: false, message: 'Validation error', data: validator.errors.messages }
    end

    user = User.find_by(email: params[:email])
    if !user || Password.new(user.password) != validator.password
      return render json: { success: false, message: 'User not found', data: {} }
    end

    data = { user: user.attributes.slice('id_user', 'name', 'email', 'phone_number'), access_token: jwt_encode(id_user: user[:id_user]) }
    render json: { success: true, messages: 'Login success', data: }
  end

  def register
    post_params = params.permit(:name, :email, :phone_number, :password)
    post_params[:password] = User.generate_password(post_params[:password]) if post_params[:password]
    user = User.new(post_params)

    if user.validate
      user.save
      data = { user: user.attributes.slice('id_user', 'name', 'email', 'phone_number') }
      render json: { success: true, message: 'Account successfully created', data: }
    else
      data = { errors: user.errors.messages }
      render json: { success: false, message: 'Validation error', data: }
    end
  rescue StandardError => e
    render json: { success: false, message: e, data: {} }
  end

  def forgot_password; end

  private

  def insert_params
    params.permit(:name, :email, :phone_number, :password)
  end
end
