class AddBaseThemeIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :base_theme_id, :integer
  end
end
