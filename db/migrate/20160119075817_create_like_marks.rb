class CreateLikeMarks < ActiveRecord::Migration
  def change
    create_table :like_marks do |t|
      t.integer :user_id
      t.integer :likeble_entity_id
      t.string :likeble_entity_type
      #t.references :user, index: true, foreign_key: true
      #t.references :likeble_entity, polymorphic: true, index: true
      
      t.timestamps null: false
    end
  end
end
