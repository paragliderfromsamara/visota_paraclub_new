class AddWhyDeleteMessageToTheme < ActiveRecord::Migration
  def change
    add_column :themes, :why_delete_message, :string
  end
end
