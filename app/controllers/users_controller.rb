class UsersController < ApplicationController
  def stats
    user_id = params[:id]
    total_courses = CourseRecord.count
    total_lessons = LessonRecord.count
    completed_lessons = UserProgressRecord.where(user_id: user_id, completed: true).count
    course_stats = CourseRecord.all.map do |course|
      lessons = LessonRecord.where(course_id: course.aggregate_id)
      total = lessons.count
      completed = UserProgressRecord.where(user_id: user_id, lesson_id: lessons.pluck(:aggregate_id), completed: true).count
      percent = total > 0 ? (completed.to_f / total * 100).round : 0
      { course_id: course.aggregate_id, completion_percent: percent }
    end
    render json: {
      user_id: user_id,
      total_courses: total_courses,
      total_lessons: total_lessons,
      completed_lessons: completed_lessons,
      course_stats: course_stats
    }
  end
end 