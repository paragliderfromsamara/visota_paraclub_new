class CreatePhotoAlbumLikeMarks < ActiveRecord::Migration
 def change
    create_table :photo_album_like_marks do |t|
      t.integer :user_id
      t.integer :photo_album_id
    end
 end
end
