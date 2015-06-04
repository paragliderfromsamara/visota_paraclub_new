class TopicNotification < ActiveRecord::Base
	attr_accessible :user_id, :topic_id
	belongs_to :topic
	belongs_to :user
end