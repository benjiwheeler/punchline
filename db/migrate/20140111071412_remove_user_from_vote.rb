class RemoveUserFromVote < ActiveRecord::Migration
  def change
    remove_reference :votes, :user, index: true
  end
end
