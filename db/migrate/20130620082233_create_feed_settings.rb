class CreateFeedSettings < ActiveRecord::Migration
  def change
    create_table :feed_settings do |t|
      t.integer :user_id
	  t.integer :entities_on_page
      t.string :new_album
	  t.string :new_video
	  t.string :new_article
	  t.string :answer_to_user
	  t.string :answer_in_user_theme
	  t.string :photo_comments
	  t.string :video_comments

      t.timestamps
    end
  end
end