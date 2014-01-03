class AddFieldsToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :user_real_name, :string
    add_column :tweets, :user_screen_name, :string
    add_column :tweets, :followers, :integer
    add_column :tweets, :friends, :integer
    add_column :tweets, :statuses_count, :integer
  end
end
