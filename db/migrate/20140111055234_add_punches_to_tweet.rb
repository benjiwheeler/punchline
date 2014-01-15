class AddPunchesToTweet < ActiveRecord::Migration
  def change
    add_reference :tweets, :punch, index: true
  end
end
