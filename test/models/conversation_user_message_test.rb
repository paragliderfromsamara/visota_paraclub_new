require 'test_helper'

class ConversationUserMessageTest < ActiveSupport::TestCase
  setup do 
    @conversationForCnvUsrMsgDestroyTest = Conversation.create(assigned_users: [2021, 2031], multiple_users_flag: false)
    @message_1 = @conversationForCnvUsrMsgDestroyTest.conversation_messages.create(content: defaultTextContent, user_id: 2021)
    @message_2 = @conversationForCnvUsrMsgDestroyTest.conversation_messages.create(content: defaultTextContent, user_id: 2031)
    @message_3 = @conversationForCnvUsrMsgDestroyTest.conversation_messages.create(content: defaultTextContent, user_id: 2031)
  end
  
  test "Если сообщение не привязано ни к одному пользователю из беседы оно должно удаляться" do
    #cnt = ConversationUserMessage.count
    assert_no_difference("ConversationMessage.count", "Сообщение удалилось при наличии ссылки") do
      @message_1.conversation_user_messages.first.destroy
    end
    assert_difference("ConversationMessage.count", -1, "Сообщение не удалилось при отсутствии ссылок") do
      @message_1.conversation_user_messages.first.destroy
    end
  end
  # test "the truth" do
  #   assert true
  # end
end
