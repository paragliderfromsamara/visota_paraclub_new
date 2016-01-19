class AddVoteTypeIdToVote < ActiveRecord::Migration
  def change
    add_column :votes, :vote_type_id, :integer
  end
end
