require "jwt"
require "securerandom"
require "uuidtools"

class AuthController < ApplicationController
  skip_before_action :authenticate_request!

  def login
    name = params[:name] || "user"
    user_id = UUIDTools::UUID.sha1_create(UUIDTools::UUID_DNS_NAMESPACE, name).to_s
    token = JWT.encode({ user_id: user_id }, 'my$ecretK3y', 'HS256')
    render json: { token: token, user_id: user_id, name: name }
  end
end 