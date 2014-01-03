class AddIndexOnHashtag < ActiveRecord::Migration
  def change
    add_index :memes, :tag
  end
end
