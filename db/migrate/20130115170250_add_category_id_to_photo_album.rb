class AddCategoryIdToPhotoAlbum < ActiveRecord::Migration
  def change
    add_column :photo_albums, :category_id, :integer
  end
end
