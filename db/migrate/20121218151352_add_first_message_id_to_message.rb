class AddFirstMessageIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :first_message_id, :integer
  end
end
