class AddOnlineFlagToStep < ActiveRecord::Migration
  def change
    add_column :steps, :online_flag, :bool
  end
end
