class AddPhotoAlbumIdAndArticleIdAndVideoIdAndUpdaterIdToTheme < ActiveRecord::Migration
  def change
    add_column :themes, :photo_album_id, :integer
    add_column :themes, :video_id, :integer
    add_column :themes, :article_id, :integer
    add_column :themes, :updater_id, :integer
  end
end
