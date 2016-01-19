class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string :name
      t.integer :user_id
      t.integer :topic_id
      t.integer :status_id
      t.integer :message_id
      t.datetime :last_message_date

      t.timestamps
    end
  end
end
