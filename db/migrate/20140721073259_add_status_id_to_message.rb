class AddStatusIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :status_id, :integer
  end
end
