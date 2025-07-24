class CoursesController < ApplicationController
  def index
    courses = CourseRecord.all
    courses = courses.where('title ILIKE ?', "%#{params[:title]}%") if params[:title].present?
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10
    total = courses.count
    courses = courses.offset((page - 1) * per_page).limit(per_page)
    render json: {
      data: courses.map { |c| course_payload(c) },
      meta: {
        page: page,
        per_page: per_page,
        total: total,
        total_pages: (total / per_page.to_f).ceil
      }
    }
  end

  def show
    course = CourseRecord.find_by(id: params[:id])
    return render json: { error: 'Not Found' }, status: :not_found unless course
    render json: course_payload(course)
  end

  def create
    course = CourseRecord.create!(
      title: params[:title],
      description: params[:description]
    )
    render json: { id: course.id }, status: :created
  end

  def update
    course = CourseRecord.find_by(id: params[:id])
    return render json: { error: 'Not Found' }, status: :not_found unless course
    course.update!(title: params[:title], description: params[:description])
    head :no_content
  end

  def destroy
    course = CourseRecord.find_by(id: params[:id])
    return render json: { error: 'Not Found' }, status: :not_found unless course
    course.destroy!
    head :no_content
  end

  private

  def course_payload(course)
    lessons = LessonRecord.where(course_id: course.id)
    total = lessons.count
    completed = UserProgressRecord.where(lesson_id: lessons.pluck(:id), completed: true).distinct.count(:lesson_id)
    percent = total > 0 ? (completed.to_f / total * 100).round : 0
    course.as_json.merge(completion_percent: percent)
  end
end 