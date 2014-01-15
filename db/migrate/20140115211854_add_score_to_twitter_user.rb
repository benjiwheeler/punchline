class AddScoreToTwitterUser < ActiveRecord::Migration
  def change
    add_column :twitter_users, :score, :float
  end
end
