class ChangePrevStatusIdInTheme < ActiveRecord::Migration
  def change
    rename_column :themes, :prev_status_id, :theme_type_id
  end
end
