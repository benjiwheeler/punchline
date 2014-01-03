class RmTextFromHashtag < ActiveRecord::Migration
  def change
    remove_column :hashtags, :text
  end
end
