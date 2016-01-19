class AddPrivateFlagToVote < ActiveRecord::Migration
  def change
    add_column :votes, :private_flag, :integer
  end
end
