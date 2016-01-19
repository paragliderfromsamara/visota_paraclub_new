class CreatePhotoAlbums < ActiveRecord::Migration
  def change
    create_table :photo_albums do |t|
      t.integer :main_photo_id
      t.integer :user_id
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
