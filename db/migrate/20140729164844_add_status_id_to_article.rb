class AddStatusIdToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :status_id, :integer
  end
end
