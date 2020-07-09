class UserMailer < ApplicationMailer
  def task_created
    user = params[:user]
    @task = params[:task]

    mail(from: 'noreply@taskmanager.com', to: user.email, subject: 'New Task Created')
  end

  def task_updated
    user = params[:user]
    @task = params[:task]

    mail(from: 'noreply@taskmanager.com', to: user.email, subject: 'Task Updated')
  end

  def task_deleted
    user = params[:user]
    @task = params[:task]

    mail(from: 'noreply@taskmanager.com', to: user.email, subject: 'Task Deleted')
  end

  def password_reset(user)
    @user = user
    mail(from: 'noreply@taskmanager.com', to: user.email, subject: 'Password reset')
  end

  def something_wrong
    user = params[:user]
    task = params[:task]

    mail(from: 'noreply@taskmanager.com', to: user.email, subject: 'Something wrong')
  end
end
