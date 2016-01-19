class AddThemeIdToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :theme_id, :integer
  end
end
