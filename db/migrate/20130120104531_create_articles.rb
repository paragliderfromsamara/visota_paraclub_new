class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :user_id
      t.integer :article_type_id
      t.string :name
      t.string :content

      t.timestamps
    end
  end
end
