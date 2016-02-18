class AddWhyDeleteMessageToUser < ActiveRecord::Migration
  def change
    add_column :users, :why_delete_message, :string
  end
end
