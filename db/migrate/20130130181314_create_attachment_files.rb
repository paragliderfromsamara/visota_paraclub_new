class CreateAttachmentFiles < ActiveRecord::Migration
  def change
    create_table :attachment_files do |t|
      t.string :name
      t.string :link
	  t.integer :article_id
	  t.integer :user_id
      t.timestamps
    end
  end
end
