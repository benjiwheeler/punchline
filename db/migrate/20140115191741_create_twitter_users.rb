class CreateTwitterUsers < ActiveRecord::Migration
  def change
    create_table :twitter_users do |t|
      t.references :user, index: true
      t.string :name
      t.string :screen_name
      t.integer :followers
      t.integer :friends
      t.integer :statuses_count

      t.timestamps
    end
  end
end
