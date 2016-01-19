class AddArticleIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :article_id, :integer
  end
end
