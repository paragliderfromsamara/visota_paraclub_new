class AddVoteIdToVoice < ActiveRecord::Migration
  def change
    add_column :voices, :vote_id, :integer
  end
end
