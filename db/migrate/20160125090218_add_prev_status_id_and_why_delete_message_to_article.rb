class AddPrevStatusIdAndWhyDeleteMessageToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :prev_status_id, :integer
    add_column :articles, :why_delete_message, :string
  end
end
