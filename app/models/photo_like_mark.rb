class PhotoLikeMark < ActiveRecord::Base
	attr_accessible :user_id, :photo_id
	belongs_to :photo
	belongs_to :user
end