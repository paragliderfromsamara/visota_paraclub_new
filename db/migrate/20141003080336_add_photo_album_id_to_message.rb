class AddPhotoAlbumIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :photo_album_id, :integer
  end
end
