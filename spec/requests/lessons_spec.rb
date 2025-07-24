require 'rails_helper'
require 'jwt'

describe 'Lessons API', type: :request do
  let(:user_id) { SecureRandom.uuid }
  let(:jwt_token) { JWT.encode({ user_id: user_id }, 'my$ecretK3y', 'HS256') }
  let(:auth_header) { { 'Authorization' => "Bearer #{jwt_token}" } }
  let!(:course) { CourseRecord.create!(title: 'Test Course', description: 'A course') }
  let(:lesson_params) { { title: 'Test Lesson', content: 'A lesson', course_id: course.id } }

  it 'creates a lesson' do
    post '/lessons', params: lesson_params, headers: auth_header
    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body)['id']).to be_present
  end

  it 'lists lessons' do
    post '/lessons', params: lesson_params, headers: auth_header
    get '/lessons', headers: auth_header
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    titles = body.map { |l| l['title'] }
    expect(titles).to include('Test Lesson')
  end

  it 'shows a lesson' do
    post '/lessons', params: lesson_params, headers: auth_header
    id = JSON.parse(response.body)['id']
    get "/lessons/#{id}", headers: auth_header
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['title']).to eq('Test Lesson')
  end

  it 'updates a lesson' do
    post '/lessons', params: lesson_params, headers: auth_header
    id = JSON.parse(response.body)['id']
    patch "/lessons/#{id}", params: { title: 'Updated', content: 'New content' }, headers: auth_header
    expect(response).to have_http_status(:no_content)
    get "/lessons/#{id}", headers: auth_header
    expect(JSON.parse(response.body)['title']).to eq('Updated')
  end

  it 'deletes a lesson' do
    post '/lessons', params: lesson_params, headers: auth_header
    id = JSON.parse(response.body)['id']
    delete "/lessons/#{id}", headers: auth_header
    expect(response).to have_http_status(:no_content)
    get "/lessons/#{id}", headers: auth_header
    expect(response).to have_http_status(:not_found).or have_http_status(:unprocessable_entity)
  end

  it 'marks a lesson as complete' do
    post '/lessons', params: lesson_params, headers: auth_header
    lesson_id = JSON.parse(response.body)['id']
    post "/lessons/#{lesson_id}/complete", headers: auth_header
    expect(response).to have_http_status(:ok).or have_http_status(:no_content)
    # Optionally, check that the progress record exists and is correct:
    progress = UserProgressRecord.find_by(user_id: user_id, lesson_id: lesson_id)
    expect(progress).to be_present
    expect(progress.completed).to eq(true)
  end
end 
