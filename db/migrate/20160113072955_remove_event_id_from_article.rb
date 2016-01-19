class RemoveEventIdFromArticle < ActiveRecord::Migration
  def change
    remove_column :articles, :event_id, :integer
  end
end
