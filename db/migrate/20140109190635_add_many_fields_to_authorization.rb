class AddManyFieldsToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :nickname, :string
    add_column :authorizations, :first_name, :string
    add_column :authorizations, :last_name, :string
    add_column :authorizations, :location, :string
    add_column :authorizations, :description, :string
    add_column :authorizations, :image, :string
    add_column :authorizations, :phone, :string
    add_column :authorizations, :urls, :json
    add_column :authorizations, :raw_info, :json
  end
end
