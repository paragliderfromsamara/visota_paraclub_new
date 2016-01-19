class CreateVideoFolders < ActiveRecord::Migration
  def change
    create_table :video_folders do |t|
      t.string :name
      t.string :description
      t.integer :user_id

      t.timestamps
    end
  end
end
