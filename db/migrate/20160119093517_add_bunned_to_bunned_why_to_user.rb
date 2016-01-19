class AddBunnedToBunnedWhyToUser < ActiveRecord::Migration
  def change
    add_column :users, :bunned_to, :datetime
    add_column :users, :bunned_why, :string
  end
end
