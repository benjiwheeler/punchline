class CreatePunches < ActiveRecord::Migration
  def change
    create_table :punches do |t|
      t.references :user, index: true
      t.string :text

      t.timestamps
    end
  end
end
