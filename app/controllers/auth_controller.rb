require "jwt"

class AuthController < ApplicationController
  skip_before_action :authenticate_request!

  def login
    user_id = params[:user_id] || "user-1"
    token = JWT.encode({ user_id: user_id }, 'my$ecretK3y', 'HS256')
    render json: { token: token }
  end
end 