class CreateThemeSteps < ActiveRecord::Migration
  def change
    create_table :theme_steps do |t|
      t.integer :theme_id
      t.integer :user_id
      t.integer :last_message_id
      t.datetime :last_visit_date
      
      #t.timestamps null: false
    end
  end
end
