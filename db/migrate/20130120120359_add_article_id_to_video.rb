class AddArticleIdToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :article_id, :integer
  end
end
