class ApplicationController < ActionController::API
  before_action :authenticate_request!
  attr_reader :current_user_id

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
end 