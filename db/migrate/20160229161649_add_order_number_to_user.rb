class AddOrderNumberToUser < ActiveRecord::Migration
  def change
    add_column :users, :order_number, :integer
  end
end
