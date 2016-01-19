class AddThemeIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :theme_id, :integer
  end
end
