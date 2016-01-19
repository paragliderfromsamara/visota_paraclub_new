class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|
      t.string :to
      t.string :copy
      t.string :from
      t.string :subject
      t.string :content
      t.integer :user_id

      t.timestamps
    end
  end
end
