class AddShortContentToEvent < ActiveRecord::Migration
  def change
    add_column :events, :short_content, :string
  end
end
