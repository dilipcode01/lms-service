class LessonsController < ApplicationController
  def index
    lessons = LessonRecord.all
    render json: lessons
  end

  def show
    lesson = LessonRecord.find(params[:id])
    render json: lesson
  end

  def create
    command = CreateLessonCommand.new(
      aggregate_id: Sequent.new_uuid,
      course_id: params[:course_id],
      title: params[:title],
      content: params[:content]
    )
    Sequent.command_service.execute_commands(command)
    render json: { id: command.aggregate_id }, status: :created
  end

  def update
    command = UpdateLessonCommand.new(
      aggregate_id: params[:id],
      title: params[:title],
      content: params[:content]
    )
    Sequent.command_service.execute_commands(command)
    head :no_content
  end

  def destroy
    command = DeleteLessonCommand.new(aggregate_id: params[:id])
    Sequent.command_service.execute_commands(command)
    head :no_content
  end

  def complete
    command = CompleteLessonCommand.new(
      aggregate_id: params[:user_id],
      user_id: params[:user_id],
      lesson_id: params[:id]
    )
    Sequent.command_service.execute_commands(command)
    head :no_content
  end
end 