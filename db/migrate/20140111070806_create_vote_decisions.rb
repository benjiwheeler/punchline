class CreateVoteDecisions < ActiveRecord::Migration
  def change
    create_table :vote_decisions do |t|
      t.references :user, index: true

      t.timestamps
    end
  end
end
