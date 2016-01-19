class AddArticleIdToPhotoAlbum < ActiveRecord::Migration
  def change
    add_column :photo_albums, :article_id, :integer
  end
end
