class AddRepeatableDefaultToVoteDecision < ActiveRecord::Migration
  def change
    change_column :vote_decisions, :is_repeatable, :boolean, default: false
  end
end
