class AddThemeIdToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :theme_id, :integer
  end
end
