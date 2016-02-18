class AddPrevStatusIdAndWhyDeleteMessageToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :prev_status_id, :integer
    add_column :messages, :why_delete_message, :string
  end
end
