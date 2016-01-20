class AddPreviousGroupIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :prev_group_id, :integer
  end
end
