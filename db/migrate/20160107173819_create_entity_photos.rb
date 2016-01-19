class CreateEntityPhotos < ActiveRecord::Migration
  def change
    create_table :entity_photos do |t|
      t.integer :photo_id
      t.integer :p_entity_id
      t.string :p_entity_type
      t.integer :visibility_status_id

      t.timestamps null: false
    end
  end
end
