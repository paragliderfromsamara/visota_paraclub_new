class AddEventIdToPhotoAlbum < ActiveRecord::Migration
  def change
    add_column :photo_albums, :event_id, :integer
  end
end
