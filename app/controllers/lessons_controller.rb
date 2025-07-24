class LessonsController < ApplicationController
  def index
    lessons = LessonRecord.all
    render json: lessons
  end

  def show
    lesson = LessonRecord.find_by(id: params[:id])
    return render json: { error: 'Not Found' }, status: :not_found unless lesson
    render json: lesson
  end

  def create
    lesson = LessonRecord.create!(
      course_id: params[:course_id],
      title: params[:title],
      content: params[:content]
    )
    render json: { id: lesson.id }, status: :created
  end

  def update
    lesson = LessonRecord.find_by(id: params[:id])
    return render json: { error: 'Not Found' }, status: :not_found unless lesson
    lesson.update!(title: params[:title], content: params[:content])
    head :no_content
  end

  def destroy
    lesson = LessonRecord.find_by(id: params[:id])
    return render json: { error: 'Not Found' }, status: :not_found unless lesson
    lesson.destroy!
    head :no_content
  end

  # POST /lessons/:id/complete
  def complete
    lesson = LessonRecord.find_by(id: params[:id])
    return render json: { error: 'Not Found' }, status: :not_found unless lesson
    user_id = current_user_id # Use from JWT
    unless user_id.present?
      return render json: { error: 'user_id required' }, status: :bad_request
    end
    progress = UserProgressRecord.find_or_initialize_by(user_id: user_id, lesson_id: lesson.id)
    progress.completed = true
    progress.save!
    render json: { message: 'Lesson marked as completed' }, status: :ok
  end
end
