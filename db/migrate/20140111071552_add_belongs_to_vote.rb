class AddBelongsToVote < ActiveRecord::Migration
  def change
    add_reference :votes, :punch, index: true
    add_reference :votes, :vote_decision, index: true
  end
end
