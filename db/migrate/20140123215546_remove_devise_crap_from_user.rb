class RemoveDeviseCrapFromUser < ActiveRecord::Migration
  def change
    rename_column :users, :email, :key
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :encrypted_password
  end
end
