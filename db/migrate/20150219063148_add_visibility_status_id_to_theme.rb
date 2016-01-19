class AddVisibilityStatusIdToTheme < ActiveRecord::Migration
  def change
    add_column :themes, :visibility_status_id, :integer
  end
end
