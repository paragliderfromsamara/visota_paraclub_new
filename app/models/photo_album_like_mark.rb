class PhotoAlbumLikeMark < ActiveRecord::Base
	attr_accessible :user_id, :photo_album_id
	belongs_to :photo_album
	belongs_to :user
end