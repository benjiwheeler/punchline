class AddCreatedAtToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :created_in_twitter_at, :datetime
  end
end
