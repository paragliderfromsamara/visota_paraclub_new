class CreateConversationUserMessages < ActiveRecord::Migration
  def change
    create_table :conversation_user_messages do |t|
      t.integer :user_id
      t.integer :conversation_message_id

      t.timestamps null: false
    end
  end
end
