class AddRepeatableDefaultToVote < ActiveRecord::Migration
  def change
    add_column :votes, :is_repeatable, :boolean, default: false
  end
end
