class AddPostDateToEvent < ActiveRecord::Migration
  def change
    add_column :events, :post_date, :datetime
  end
end
