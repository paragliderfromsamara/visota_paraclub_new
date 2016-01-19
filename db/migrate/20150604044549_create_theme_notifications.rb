class CreateThemeNotifications < ActiveRecord::Migration
 def change
    create_table :theme_notifications do |t|
      t.integer :user_id
      t.integer :theme_id
    end
 end
end
