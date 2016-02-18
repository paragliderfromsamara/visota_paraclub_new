class CreateConversationMessages < ActiveRecord::Migration
  def change
    create_table :conversation_messages do |t|
      t.integer :user_id
      t.integer :conversation_id
      t.string :content

      t.timestamps null: false
    end
  end
end
