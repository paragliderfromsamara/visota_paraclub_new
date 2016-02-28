class AddEquipmentPartIdToTheme < ActiveRecord::Migration
  def change
    add_column :themes, :equipment_part_id, :integer
  end
end
