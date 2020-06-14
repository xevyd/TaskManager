require 'rollbar'

Rollbar.configure do |config|
  config.access_token = 'a6bb8fc6044247b79d3ff36311b29e5f'
end

class Api::V1::TasksController < Api::V1::ApplicationController
  def index
    tasks = Task.order(created_at: :desc).ransack(ransack_params).
      result.
      includes([:author]).
      includes([:assignee]).
      page(page).
      per(per_page)

    respond_with(tasks, each_serializer: TaskSerializer, root: 'items', meta: build_meta(tasks))
  end

  def show
    task = Task.find(params[:id])

    respond_with(task, serializer: TaskSerializer)
    Rollbar.error('show')
  end

  def create
    task = current_user.my_tasks.new(task_params)
    task.save

    respond_with(task, serializer: TaskSerializer, location: nil)
  end

  def update
    task = Task.find(params[:id])
    task.update(task_params)

    respond_with(task, serializer: TaskSerializer)
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy

    respond_with(task)
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :assignee_id, :state_event)
  end
end
