class AddStatusIdToPhotoAlbum < ActiveRecord::Migration
  def change
    add_column :photo_albums, :status_id, :integer
  end
end
