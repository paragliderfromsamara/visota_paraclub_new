class AddUpdaterIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :updater_id, :integer
  end
end
