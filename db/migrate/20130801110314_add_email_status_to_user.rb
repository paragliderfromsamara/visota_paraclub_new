class AddEmailStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :email_status, :string
  end
end
