class CreateTableVoices < ActiveRecord::Migration
 def change
    create_table :voices do |t|
      t.integer :vote_value_id
	  t.integer :user_id  
	  
      t.timestamps
    end
  end
end
