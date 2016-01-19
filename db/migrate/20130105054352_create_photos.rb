class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :photo_album_id
      t.integer :user_id
      t.integer :category_id
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
