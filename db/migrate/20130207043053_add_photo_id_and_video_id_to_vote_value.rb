class AddPhotoIdAndVideoIdToVoteValue < ActiveRecord::Migration
  def change
    add_column :vote_values, :photo_id, :integer
    add_column :vote_values, :video_id, :integer
  end
end
