class AddIndexToTweets < ActiveRecord::Migration
    def self.up
      add_index :tweets, :tweet_id
    end

    def self.down
      remove_index :tweets, :column => :tweet_id
    end
end
