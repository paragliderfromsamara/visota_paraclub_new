class AddMiniLinkToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :mini_link, :string
  end
end
