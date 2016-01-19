class AddVisibilityStatusIdToPhotoAlbum < ActiveRecord::Migration
  def change
    add_column :photo_albums, :visibility_status_id, :integer
  end
end
