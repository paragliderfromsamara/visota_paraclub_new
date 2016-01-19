class CreatePhotoLikeMarks < ActiveRecord::Migration
 def change
    create_table :photo_like_marks do |t|
      t.integer :user_id
      t.integer :photo_id
    end
 end
end
