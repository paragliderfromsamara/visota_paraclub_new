class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :name
      t.integer :user_id
      t.integer :video_folder_id
      t.string :link

      t.timestamps
    end
  end
end
