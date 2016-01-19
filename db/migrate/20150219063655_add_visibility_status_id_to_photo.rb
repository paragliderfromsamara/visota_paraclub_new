class AddVisibilityStatusIdToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :visibility_status_id, :integer
  end
end
