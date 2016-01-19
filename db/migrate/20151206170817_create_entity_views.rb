class CreateEntityViews < ActiveRecord::Migration
  def change
    create_table :entity_views do |t|
      t.references :v_entity, polymorphic: true, index: true
      t.integer :counter
      t.timestamps null: false
    end
  end
end
