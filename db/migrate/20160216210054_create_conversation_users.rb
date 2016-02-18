class CreateConversationUsers < ActiveRecord::Migration
  def change
    create_table :conversation_users do |t|
      t.integer :user_id
      t.integer :conversation_id

      t.timestamps null: false
    end
  end
end
