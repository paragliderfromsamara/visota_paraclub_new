class CreateValues < ActiveRecord::Migration
  def up
	create_table :values do |t|
	  t.integer :value_id
      t.string :value

      t.timestamps
	end
  end

  def down
  end
end
