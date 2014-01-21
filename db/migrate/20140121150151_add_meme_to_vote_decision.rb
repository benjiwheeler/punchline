class AddMemeToVoteDecision < ActiveRecord::Migration
  def change
    add_reference :vote_decisions, :meme, index: true
  end
end
