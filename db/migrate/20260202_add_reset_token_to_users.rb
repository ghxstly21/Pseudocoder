class AddResetTokenToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :reset_token, :string
    add_column :users, :reset_token_expires_at, :datetime
    add_column :users, :pending_email, :string
    add_column :users, :email_confirmation_token, :string
    add_column :users, :email_confirmed_at, :datetime

    add_index :users, :reset_token, unique: true
    add_index :users, :email_confirmation_token, unique: true
  end
end
