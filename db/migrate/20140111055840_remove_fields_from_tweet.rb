class RemoveFieldsFromTweet < ActiveRecord::Migration
  def change
    remove_column :tweets, :score, :float
    remove_reference :tweets, :meme, index: true
  end
end
