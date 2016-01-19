class CreateOldMessages < ActiveRecord::Migration
  def change
    create_table :old_messages do |t|
      t.integer :user_id
      t.string :user_name
      t.string :content
      t.datetime :created_when

      t.timestamps
    end
  end
end
