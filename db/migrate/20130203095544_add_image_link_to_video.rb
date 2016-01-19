class AddImageLinkToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :image_link, :string
  end
end
