class AddThemeIdAndSizeToAttachmentFile < ActiveRecord::Migration
  def change
    add_column :attachment_files, :theme_id, :integer
    add_column :attachment_files, :size, :integer
  end
end
