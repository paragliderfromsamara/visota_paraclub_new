class RemoveUnusedTables < ActiveRecord::Migration
  def change
    drop_table :photo_like_marks
    drop_table :photo_album_like_marks
    drop_table :article_types
    drop_table :categories
    drop_table :feed_settings
    drop_table :letters
    drop_table :user_groups
    drop_table :values
    drop_table :video_folders
    drop_table :video_like_marks
  end
end
