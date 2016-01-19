class AddMergeWithToTheme < ActiveRecord::Migration
  def change
    add_column :themes, :merge_with, :integer
  end
end
