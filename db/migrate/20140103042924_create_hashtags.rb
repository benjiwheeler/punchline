class CreateHashtags < ActiveRecord::Migration
  def change
    add_column :hashtags, :content, :string
  end
end
