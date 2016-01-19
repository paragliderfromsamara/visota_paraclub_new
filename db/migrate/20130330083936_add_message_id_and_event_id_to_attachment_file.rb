class AddMessageIdAndEventIdToAttachmentFile < ActiveRecord::Migration
  def change
    add_column :attachment_files, :message_id, :integer
    add_column :attachment_files, :event_id, :integer
  end
end
