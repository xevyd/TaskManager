class User < ApplicationRecord
  has_secure_password

  has_many :my_tasks, class_name: 'Task', foreign_key: :author_id
  has_many :assigned_tasks, class_name: 'Task', foreign_key: :assignee_id

  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def create_password_reset_token
    self.password_reset_token = User.new_token
    update_attribute(:password_reset_token, User.digest(password_reset_token))
    update_attribute(:password_reset_token_sent_at, Time.zone.now)
  end

  def remove_password_reset_token
    update_attribute(:password_reset_token, nil)
    update_attribute(:password_reset_token_sent_at, nil)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_token_expired?
    password_reset_token_sent_at < 24.hours.ago
  end

  def self.find_by_password_reset_token(token)
    user = User.find_by(password_reset_token: token)
    if user && (not user.password_reset_token_expired?)
      user
    end
  end
end
