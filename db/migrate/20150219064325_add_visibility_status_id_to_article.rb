class AddVisibilityStatusIdToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :visibility_status_id, :integer
  end
end
