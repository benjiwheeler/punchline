class RemoveRepeatableDefaultFromVoteDecision < ActiveRecord::Migration
  def change
    remove_column :vote_decisions, :is_repeatable, :boolean
  end
end
