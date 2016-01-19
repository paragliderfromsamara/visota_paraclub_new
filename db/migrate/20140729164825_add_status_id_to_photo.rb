class AddStatusIdToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :status_id, :integer
  end
end
