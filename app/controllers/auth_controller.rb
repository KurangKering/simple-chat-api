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

    data = { user: user.attributes.slice('id_user', 'name', 'email', 'phone_number', 'image'), access_token: jwt_encode(id_user: user[:id_user]) }
    render json: { success: true, messages: 'Login success', data: }
  end

  def register
    post_params = params.permit(:name, :email, :phone_number, :image, :password)
    post_params[:password] = User.generate_password(post_params[:password]) if post_params[:password]
    user = User.new(post_params.except(:image))
    image_error = false
    if ImageRepository.input_type(params[:image]) != 'image'
      image_error = true
    end
    if user.validate && !image_error
      user.image = ImageRepository.insert_image(params[:image])
      user.save
      data = user.reload.attributes.slice('id_user', 'name', 'email', 'phone_number', 'image')
      render json: { success: true, message: 'Account successfully created', data: }
    else
      if image_error
        user.errors.add(:image, 'must be gif, jpg, or png image')
      end
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
