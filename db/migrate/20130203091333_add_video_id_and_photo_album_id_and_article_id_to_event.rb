class AddVideoIdAndPhotoAlbumIdAndArticleIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :video_id, :integer
    add_column :events, :photo_album_id, :integer
    add_column :events, :article_id, :integer
  end
end
