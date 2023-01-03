class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_request

  skip_before_action :authenticate_request, only: [:index]

  def index
    render json: { title: 'Simple Chat Api' }
  end

  private

  def authenticate_request
    header = request.headers['Authorization']

    header = header.split(' ') if header

    render json: { success: false, message: 'No token provided', data: {} }, status: :unauthorized unless header

    decoded = jwt_decode(header)

    @current_user = User.find(decoded[:id_user])

    render json: { success: false, message: 'User not found', data: {} }, status: :unauthorized unless @current_user
  rescue StandardError => e
    render json: { success: false, message: e, data: {} }, status: :unauthorized
  end
end
