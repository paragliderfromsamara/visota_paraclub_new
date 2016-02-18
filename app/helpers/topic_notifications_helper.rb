module TopicNotificationsHelper
	def multipleTopicNtfUpd(ntfData)
		d = true
		topics = Topic.all
		if topics != []
			topics.each do |t|
				ntf = current_user.getTopicNotification(t.id)
				if ntf.nil? and ntfData[t.id.to_s.to_sym] == '1'
					ntf = TopicNotification.new(:topic_id => t.id, :user_id => current_user.id)
					d = false unless ntf.save
        elsif !ntf.nil? and ntfData[t.id.to_s.to_sym] == '0'
					d = false unless ntf.delete
				end
			end
		end
		return d
	end
	def singleTopicNtfUpd(ntfData)
		#to_do
	end
end
