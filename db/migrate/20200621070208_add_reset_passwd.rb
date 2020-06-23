class AddResetPasswd < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :password_reset_token, :string, unique: true
    add_column :users, :password_reset_token_sent_at, :datetime
  end
end
