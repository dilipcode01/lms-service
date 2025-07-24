class ApplicationController < ActionController::API
  before_action :authenticate_request!

  private

  def authenticate_request!
    header = request.headers['Authorization']
    token = header&.split(' ')&.last
    begin
      payload, = JWT.decode(token, 'my$ecretK3y', true, { algorithm: 'HS256' })
      @current_user_id = payload['user_id']
    rescue
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def current_user_id
    @current_user_id
  end
end 