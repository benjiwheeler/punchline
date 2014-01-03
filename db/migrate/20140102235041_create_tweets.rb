class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :tweet_id
      t.references :hashtag, index: true
      t.json :attrs

      t.timestamps
    end
  end
end
