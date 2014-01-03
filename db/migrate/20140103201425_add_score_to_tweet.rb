class AddScoreToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :score, :float
  end
end
