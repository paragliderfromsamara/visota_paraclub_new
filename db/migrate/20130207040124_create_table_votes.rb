class CreateTableVotes < ActiveRecord::Migration
 def change
    create_table :votes do |t|
      t.integer :user_id
	  t.integer :topic_id
    t.integer :message_id
	  t.string :title
	  t.string :content
	  t.integer :status_id
      t.datetime :start_date
      t.datetime :end_date
      
      

      t.timestamps
    end
  end
end
