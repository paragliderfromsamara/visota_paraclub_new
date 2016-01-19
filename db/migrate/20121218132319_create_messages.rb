class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :topic_id
      t.integer :message_id
      t.integer :photo_id
      t.integer :video_id
      t.string :theme
      t.string :content

      t.timestamps
    end
  end
end
