class RemovePhotoAlbumIdAndVideoIdAndArticleIdAndMergeWithFromThemes < ActiveRecord::Migration
  def change
    remove_column :themes, :photo_album_id, :integer
    remove_column :themes, :video_id, :integer
    remove_column :themes, :article_id, :integer
    remove_column :themes, :merge_with, :integer
  end
end
