class ChangeIdInTweet < ActiveRecord::Migration
  def change
    remove_column :tweets, :tweet_id
    add_column :tweets, :tweet_id, :integer
  end
end
