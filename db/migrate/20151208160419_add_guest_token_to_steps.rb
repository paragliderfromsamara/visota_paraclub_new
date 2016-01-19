class AddGuestTokenToSteps < ActiveRecord::Migration
  def change
    add_column :steps, :guest_token, :string
  end
end
