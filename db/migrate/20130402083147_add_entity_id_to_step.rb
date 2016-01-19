class AddEntityIdToStep < ActiveRecord::Migration
  def change
    add_column :steps, :entity_id, :integer
  end
end
