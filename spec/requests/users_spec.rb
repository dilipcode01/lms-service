require 'rails_helper'
require 'jwt'

describe 'Users API', type: :request do
  let(:jwt_token) { JWT.encode({ user_id: 'user-1' }, 'my$ecretK3y', 'HS256') }
  let(:auth_header) { { 'Authorization' => "Bearer #{jwt_token}" } }

  it 'gets user stats' do
    get '/users/user-1/stats', headers: auth_header
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['user_id']).to eq('user-1')
  end
end 
