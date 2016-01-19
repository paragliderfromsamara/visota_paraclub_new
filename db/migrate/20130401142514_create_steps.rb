class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.integer :user_id
      t.datetime :visit_time
      t.integer :part_id
      t.integer :page_id

      t.timestamps
    end
  end
end
