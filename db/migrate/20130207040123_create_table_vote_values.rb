class CreateTableVoteValues < ActiveRecord::Migration
 def change
    create_table :vote_values do |t|
      t.integer :vote_id
	  t.string :value  
	  
      t.timestamps
    end
  end
end
