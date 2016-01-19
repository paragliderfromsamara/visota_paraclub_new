class AddVisibilityStatusIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :visibility_status_id, :integer
  end
end
