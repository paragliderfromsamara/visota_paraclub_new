class AddAccidentDateToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :accident_date, :datetime
  end
end
