class AddMessageIdToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :message_id, :integer
  end
end
