class AddPopularToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :retweet_count, :integer
    add_column :tweets, :favorite_count, :integer
    add_reference :tweets, :twitter_user, index: true
    
    remove_column :tweets, :user_real_name
    remove_column :tweets, :user_screen_name
    remove_column :tweets, :followers
    remove_column :tweets, :statuses_count
    remove_column :tweets, :friends
    
  end
end
