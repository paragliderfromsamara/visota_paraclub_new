require 'test_helper'

class ConversationMessageTest < ActiveSupport::TestCase
  test "Должен зашифровывать сообщение при создании и добавлять привязку пользователям подключенным к беседе пользователям" do
    cnv = Conversation.create(cnv_users: [201, 20], multiple_users_flag: false)
    messageText = 'New text for message на разных языках @ & * ) ( ) / \n egr gerg ппек кек ,< №'
    cnt = ConversationUserMessage.count
    msg = ConversationMessage.create(user_id: 201, content: messageText, conversation_id: cnv.id)
    assert ConversationUserMessage.count == cnt + cnv.users.size, "Привязка к пользователям не была создана"
    assert msg.content != messageText, "Текст должен быть зашифрован"
    txt = msg.decrypted_content
    assert txt == messageText, "Текст должен быть расшифрован должно быть: '#{messageText}', а получилось: #{txt}"
  end
  
  
  # test "the truth" do
  #   assert true
  # end
end
