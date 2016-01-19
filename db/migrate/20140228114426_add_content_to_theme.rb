class AddContentToTheme < ActiveRecord::Migration
  def change
    add_column :themes, :content, :string
  end
end
