class ConversationUserMessage < ActiveRecord::Base
  attr_accessible :user_id, :conversation_message_id
  belongs_to :user
  belongs_to :conversation_message
  has_one :conversation, through: :conversation_message
  
  after_destroy :check_message_assigions
  
  private 
  
  def check_message_assigions
    msgs = self.conversation_message.conversation_user_messages
    self.conversation_message.destroy if msgs.size == 0
  end
end
