class AddMultipleUsersFlagToConversation < ActiveRecord::Migration
  def change
    add_column :conversations, :multiple_users_flag, :boolean
  end
end
