require "jwt"
require "securerandom"

class AuthController < ApplicationController
  skip_before_action :authenticate_request!

  def login
    user_id = params[:user_id]
    # Ensure user_id is a valid UUID, otherwise generate one
    unless user_id.present? && user_id.match?(/^\h{8}-\h{4}-\h{4}-\h{4}-\h{12}$/)
      user_id = SecureRandom.uuid
    end
    token = JWT.encode({ user_id: user_id }, 'my$ecretK3y', 'HS256')
    render json: { token: token, user_id: user_id }
  end
end 