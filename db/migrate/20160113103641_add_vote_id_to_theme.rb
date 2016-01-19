class AddVoteIdToTheme < ActiveRecord::Migration
  def change
    add_column :themes, :vote_id, :integer
  end
end
