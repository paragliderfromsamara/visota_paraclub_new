class ConversationUser < ActiveRecord::Base
   attr_accessible :conversation_id, :user_id
   belongs_to :user
   belongs_to :conversation
end
