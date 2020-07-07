class SendTaskDeleteNotificationJob < ApplicationJob
  sidekiq_options queue: :mailers
  sidekiq_throttle_as :mailer

  def perform(task_id, assignee_id)
    user = User.find_by(id: assignee_id)
    return if user.blank?

    UserMailer.with(user: user, task: task_id).task_deleted.deliver_now
  end
end
