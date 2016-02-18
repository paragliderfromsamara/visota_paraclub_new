require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  test "Беседа должна создаваться с пользователями из массива" do
    user_1 = users(:club_pilot)
    user_2 = users(:club_friend)
    cnv = Conversation.new
     assert_difference("Conversation.count", 1, "Не удалось добавить беседу из массива") do
       cnv = Conversation.create(cnv_users: [user_1.id, user_2.id], multiple_users_flag: false)
     end
     cnv_1 = Conversation.new
     cnv_2 = Conversation.new
     assert_no_difference("ConversationUser.count") do
       cnv_1 = user_1.get_conversation(user_2)
     end
     assert_no_difference("ConversationUser.count") do
       cnv_2 = user_2.get_conversation(user_1)
     end
    assert cnv_1 == cnv_2, "Не удалось найти одинаковые диалоги для разных пользователей"
  end
  test "Беседа должна создаваться с пользователями из строки" do
    user_1 = users(:manager)
    user_2 = users(:club_friend)
    cnv = Conversation.new
     assert_difference("Conversation.count", 1, "Не удалось добавить беседу из массива") do
       cnv = Conversation.create(cnv_users: "[#{user_1.id}][#{user_2.id}]", multiple_users_flag: false)
     end
     cnv_1 = Conversation.new
     cnv_2 = Conversation.new
     assert_no_difference("ConversationUser.count") do
       cnv_1 = user_1.get_conversation(user_2)
     end
     assert_no_difference("ConversationUser.count") do
       cnv_2 = user_2.get_conversation(user_1)
     end
    assert cnv_1 == cnv_2, "Не удалось найти одинаковые диалоги для разных пользователей"
  end
  
  test "Название беседы без имени должно формироваться из имён участников, если имя не указано" do
    cnv = Conversation.create(cnv_users: [200, 206], multiple_users_flag: false)
    n = ''
    cnv_users = cnv.users
    whoGetCnv = cnv_users.first
    cnv_users = cnv_users - [whoGetCnv]
    cnv_users.each {|u| n += "#{u.name}#{', ' if u != cnv_users.last}"}
    aN = cnv.alter_name(cnv.users.first)
    assert aN == n && !aN.blank?, "Имя должно быть '#{n}', а оно '#{aN}'"
    n = ''
    cnv.users.each {|u| n += "#{u.name}#{', ' if u != cnv_users.last}"}
    aN = cnv.alter_name
    assert aN == n && !aN.blank?, "Имя должно быть '#{n}', а оно '#{aN}'"
  end
  
  test "Название беседы должно выводиться если имя указано" do
    n = 'defaultConversation'
    cnv = Conversation.create(name: n, cnv_users: [200, 202], multiple_users_flag: false)
    aN = cnv.alter_name(cnv.users.first)
    assert aN == n && !aN.blank?, "Имя должно быть '#{n}', а оно '#{aN}'"
  end
  
  test "При создании беседы должен добавляться ключ для кодировки сообщений salt" do
    cnv = Conversation.create(cnv_users: [201, 203], multiple_users_flag: false)
    assert !cnv.salt.blank? && cnv.salt.length == 24, "Ключ не заполнился"
  end
  # test "the truth" do
  #   assert true
  # end
end
