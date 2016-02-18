class AddSaltToConversationMessage < ActiveRecord::Migration
  def change
    add_column :conversation_messages, :salt, :string
  end
end
