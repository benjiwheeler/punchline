class AddMemesToPunch < ActiveRecord::Migration
  def change
    add_reference :punches, :meme, index: true
  end
end
