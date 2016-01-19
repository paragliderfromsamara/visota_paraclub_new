class CreateVideoLikeMarks < ActiveRecord::Migration
 def change
    create_table :video_like_marks do |t|
      t.integer :user_id
      t.integer :video_id
    end
 end
end
