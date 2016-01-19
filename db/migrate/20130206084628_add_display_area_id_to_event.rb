class AddDisplayAreaIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :display_area_id, :integer
  end
end
