class AddScoreToPunches < ActiveRecord::Migration
  def change
    add_column :punches, :score, :float
  end
end
