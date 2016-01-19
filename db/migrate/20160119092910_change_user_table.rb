class ChangeUserTable < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :icq
      t.string :web_site
      
    end
  end
end
