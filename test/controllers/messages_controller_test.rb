require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  setup do
    @message = messages(:themeMessage)
    @photoMessage = messages(:photoMessage)
    @messageForUpdateTest = messages(:themeMessageForMessagesTest_2)
    @messageForCreateTest = messages(:themeMessageForMessagesTest_3)
    @messageForOwnerDestroyTest = messages(:themeMessageForMessagesTest_4)
    @messageForAdminDestroyTest = messages(:themeMessageForMessagesTest_5)
    @messageForSuperAdminDestroyTest = messages(:themeMessageForMessagesTest_6)
  end

  test "Переадресация со списка всех сообщений на в topics_path" do
    get :index
    assert_redirected_to '/visota_life'
    #assert_response :success
    #assert_not_nil assigns(:messages)
  end
  
  test "should show message draft in preview mode=true for message owner" do
    comeAsClubPilot
    get :show, :id => @messageForUpdateTest, preview_mode: 'true'
    assert_response :success
  end
  
  test "SuperAdmin should show message draft in preview mode=true for message owner" do
    comeAsSuperAdmin
    get :show, :id => @messageForUpdateTest, preview_mode: 'true'
    assert_response :success
  end
  
  test "shouldn't show message draft in preview mode=false for message owner" do
    comeAsClubPilot
    get :show, :id => @messageForUpdateTest
    assert_redirected_to '/404'
  end
  
  test "shouldn't show message draft in preview mode=true for not message owner" do
    comeAsClubFriend
    get :show, :id => @messageForUpdateTest, preview_mode: 'true'
    assert_redirected_to '/404'
  end
  
  test "shouldn't show message draft in preview mode=false for not message owner" do
    comeAsClubFriend
    get :show, :id => @messageForUpdateTest
    assert_redirected_to '/404'
  end
  
  test "Guest shouldn't show message draft in preview mode=true for not message owner" do
    comeAsClubFriend
    get :show, :id => @messageForUpdateTest, preview_mode: 'true'
    assert_redirected_to '/404'
  end
  
  test "Guest shouldn't show message draft in preview mode=false for not message owner" do
    comeAsClubFriend
    get :show, :id => @messageForUpdateTest
    assert_redirected_to '/404'
  end
  
  test "guest shouldn't update message" do
    comeAsGuest
    put :update, :id => @messageForUpdateTest, :message => { :content => @messageForUpdateTest.content, :theme_id => @messageForUpdateTest.theme_id, :topic_id => @messageForUpdateTest.topic_id, :user_id => @messageForUpdateTest.user_id, :status_id => 1 }
    assert_redirected_to '/404'
  end
  
  test "Message owner should update message" do
    session[:link_after_message_save] = theme_path(@messageForUpdateTest.theme)
    comeAsClubPilot
    put :update, :id => @messageForUpdateTest, :message => { :content => @messageForUpdateTest.content, :theme_id => @messageForUpdateTest.theme_id, :topic_id => @messageForUpdateTest.topic_id, :user_id => @messageForUpdateTest.user_id, :status_id => 1 }
    assert_redirected_to session[:link_after_message_save] + "#msg_#{@messageForUpdateTest.id}"
  end
  
  test "User shouldn't destroy another's message" do
    comeAsClubPilot
    assert_no_difference('Message.count', 'Пользователю удалось удалить чужое сообщение') do
       delete :destroy, :id => @messageForOwnerDestroyTest
    end
    assert_redirected_to '/404'
  end
  
  test "User should destroy his message" do
    comeAsClubFriend
    assert_difference('Message.count', -1, 'Пользователю не удалось удалить свое сообщение') do
       delete :destroy, :id => @messageForOwnerDestroyTest
    end
    #assert_redirected_to '/404'
  end
  
  test "Admin should destroy another's message" do
    comeAsAdmin
    alreadyDeletedMessage = messages(:themeMessageForMessagesTest_7)
    assert_no_difference('Message.count','Администратору удалось удалить чужое сообщение, вместо того, чтобы перевести его в статус "to_delete"') do
       delete :destroy, :id => @messageForAdminDestroyTest
    end
    msg = Message.find(@messageForAdminDestroyTest.id)
    assert msg.status_id == 2, "Не удалось перевести сообщение в статус 'to_delete' текущий статус: #{msg.status}"
    assert_no_difference('Message.count','Администратору удалось удалить чужое сообщение в статусе "to_delete"') do
       delete :destroy, :id => alreadyDeletedMessage#@messageForAdminDestroyTest
    end
    assert_redirected_to '/404'
  end
  
  test "Super Admin should destroy another's message" do
    alreadyDeletedMessage = messages(:themeMessageForMessagesTest_7)
    comeAsSuperAdmin
    assert_no_difference('Message.count', 'Главному администратору удалось удалить чужое сообщение, вместо того, чтобы перевести его в статус "to_delete"') do
       delete :destroy, :id => @messageForSuperAdminDestroyTest
    end
    msg = Message.find(@messageForSuperAdminDestroyTest.id)
    assert msg.status_id == 2, "Не удалось перевести сообщение в статус 'to_delete' текущий статус: #{msg.status}"
    
    assert_difference('Message.count',-1,'Глвному Администратору не удалось удалить чужое сообщение в статусе "to_delete"') do
       delete :destroy, :id => msg#@messageForAdminDestroyTest
    end
    #assert_redirected_to '/404'
    #assert_redirected_to '/404'
  end
  
#  test "should get edit" do
#    get :edit, :id => @message
#    assert_response :success
#  end

 # test "should update message" do
 #   put :update, :id => @message, :message => { :content => @message.content, :first_message_id => @message.first_message_id, :message_id => @message.message_id, :photo_id => @message.photo_id, :theme => @message.theme, :theme_id => @message.theme_id, :topic_id => @message.topic_id, :updater_id => @message.updater_id, :user_id => @message.user_id, :video_id => @message.video_id }
 #   assert_redirected_to message_path(assigns(:message))
 # end

  #test "should destroy message" do
 #   assert_difference('Message.count', -1) do
  #    delete :destroy, :id => @message
 #   end

 #   assert_redirected_to messages_path
 # end
end
