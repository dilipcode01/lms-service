require 'rails_helper'
require 'jwt'

describe 'Courses API', type: :request do
  let(:course_params) { { title: 'Test Course', description: 'A course' } }
  let(:jwt_token) { JWT.encode({ user_id: 'user-1' }, 'my$ecretK3y', 'HS256') }
  let(:auth_header) { { 'Authorization' => "Bearer #{jwt_token}" } }

  it 'creates a course' do
    post '/courses', params: course_params, headers: auth_header
    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)['id']).to be_present
  end

  it 'lists courses' do
    post '/courses', params: course_params, headers: auth_header
    get '/courses', headers: auth_header
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    titles = body['data'].map { |c| c['title'] }
    expect(titles).to include('Test Course')
  end

  it 'shows a course' do
    post '/courses', params: course_params, headers: auth_header
    id = JSON.parse(response.body)['id']
    get "/courses/#{id}", headers: auth_header
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['title']).to eq('Test Course')
  end

  it 'updates a course' do
    post '/courses', params: course_params, headers: auth_header
    id = JSON.parse(response.body)['id']
    patch "/courses/#{id}", params: { title: 'Updated', description: 'New desc' }, headers: auth_header
    expect(response).to have_http_status(:no_content)
    get "/courses/#{id}", headers: auth_header
    expect(JSON.parse(response.body)['title']).to eq('Updated')
  end

  it 'deletes a course' do
    post '/courses', params: course_params, headers: auth_header
    id = JSON.parse(response.body)['id']
    delete "/courses/#{id}", headers: auth_header
    expect(response).to have_http_status(:no_content)
    get "/courses/#{id}", headers: auth_header
    expect(response).to have_http_status(:not_found).or have_http_status(:unprocessable_entity)
  end

  it 'paginates courses' do
    15.times { |i| post '/courses', params: { title: "Course \\#{i}", description: 'desc' }, headers: auth_header }
    get '/courses', params: { page: 2, per_page: 5 }, headers: auth_header
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['data'].size).to eq(5)
    expect(body['meta']['page']).to eq(2)
    expect(body['meta']['total']).to be >= 15
  end

  it 'filters courses by title' do
    post '/courses', params: { title: 'Ruby 101', description: 'desc' }, headers: auth_header
    post '/courses', params: { title: 'Rails 101', description: 'desc' }, headers: auth_header
    get '/courses', params: { title: 'Ruby' }, headers: auth_header
    body = JSON.parse(response.body)
    titles = body['data'].map { |c| c['title'] }
    expect(titles).to include('Ruby 101')
  end
end 
