class AddWhyDeleteMessageToPhotoAlbum < ActiveRecord::Migration
  def change
    add_column :photo_albums, :why_delete_message, :string
  end
end
