class AddMemeToTweet < ActiveRecord::Migration
  def change
    add_reference :tweets, :meme, index: true
    remove_column :tweets, :hashtag_id
  end
end
