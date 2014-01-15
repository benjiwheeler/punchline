class AddSalienceToVote < ActiveRecord::Migration
  def change
    add_column :votes, :value, :float
  end
end
