class AddEventIdToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :event_id, :integer
  end
end
