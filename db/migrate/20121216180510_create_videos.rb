class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :name
      t.integer :user_id
      t.integer :category_id
      t.string :link

      t.timestamps
    end
  end
end
