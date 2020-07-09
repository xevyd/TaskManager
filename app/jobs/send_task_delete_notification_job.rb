class SendTaskDeleteNotificationJob < ApplicationJob
  sidekiq_options queue: :mailers
  sidekiq_throttle_as :mailer

  def perform(task_id, assignee_id)
    user = User.find_by(id: assignee_id)
    task = Task.find_by(id: task_id)

    if user.blank?
      UserMailer.with(user: task.author, task: task).something_wrong.deliver_now
    else
      UserMailer.with(user: user, task: task_id).task_deleted.deliver_now
    end
  end
end
