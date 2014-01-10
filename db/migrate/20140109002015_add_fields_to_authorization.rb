class AddFieldsToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :oauth_token, :string
    add_column :authorizations, :oauth_expires_at, :datetime
    add_column :authorizations, :oauth_secret, :string
    add_column :authorizations, :name, :string
    add_column :authorizations, :screen_name, :string
  end
end
