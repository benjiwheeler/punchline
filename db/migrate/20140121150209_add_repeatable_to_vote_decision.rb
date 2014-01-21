class AddRepeatableToVoteDecision < ActiveRecord::Migration
  def change
    add_column :vote_decisions, :is_repeatable, :boolean
  end
end
