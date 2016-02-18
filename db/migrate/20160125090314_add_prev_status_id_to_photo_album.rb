class AddPrevStatusIdToPhotoAlbum < ActiveRecord::Migration
  def change
    add_column :photo_albums, :prev_status_id, :integer
  end
end
