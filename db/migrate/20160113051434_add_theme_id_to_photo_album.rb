class AddThemeIdToPhotoAlbum < ActiveRecord::Migration
  def change
    add_column :photo_albums, :theme_id, :integer
  end
end
