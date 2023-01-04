class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_request

  skip_before_action :authenticate_request, only: [:homepage]

  def homepage
    render json: { title: 'Simple Chat Api' }
  end

  private

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split('Bearer ')[1] if header
    unless header
      return render json: { success: false, message: 'No token provided', data: {} },
                    status: :unauthorized
    end

    decoded = jwt_decode(header)
    @current_user = User.find(decoded[:id_user])
    unless @current_user
      render json: { success: false, message: 'User not found', data: {} },
             status: :unauthorized
    end
  rescue StandardError => e
    render json: { success: false, message: e, data: {} }, status: :unauthorized
  end
end
