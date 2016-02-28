class AddThemeIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :theme_id, :integer
  end
end
