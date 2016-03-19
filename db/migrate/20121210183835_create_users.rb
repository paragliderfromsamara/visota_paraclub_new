class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :avatar
      t.string :full_name
      t.string :photo
      t.string :cell_phone
      t.string :skype
      t.string :icq
      t.string :email
      t.string :inform
      t.string :encrypted_password
      t.string :salt

      t.timestamps
    end
  end
end
