class ChangeThemeTypeIdInTheme < ActiveRecord::Migration
  def change
    change_column_null :themes, :theme_type_id, 1
  end
end
