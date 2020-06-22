class ResetPasswordFix < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :password_reset_token, :string, unique: true
  end
end
