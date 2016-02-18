class AddPrevStatusIdToTheme < ActiveRecord::Migration
  def change
    add_column :themes, :prev_status_id, :integer
  end
end
