class RemoveMessageIdFromThemes < ActiveRecord::Migration
  def change
    remove_column :themes, :message_id, :integer
  end
end
