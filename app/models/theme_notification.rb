class ThemeNotification < ActiveRecord::Base
	attr_accessible :user_id, :theme_id
	belongs_to :theme
	belongs_to :user
end