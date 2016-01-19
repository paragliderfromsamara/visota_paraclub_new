class CreateMailers < ActiveRecord::Migration
  def change
    create_table :mailers do |t|
      t.integer :user_id
      t.string :album
      t.string :video
      t.string :article
      t.string :message
      t.string :photo_comment
      t.string :video_comment
      t.string :email

      t.timestamps
    end
  end
end
