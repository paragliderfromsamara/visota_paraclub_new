require 'test_helper'

class TopicNotificationsControllerTest < ActionController::TestCase
  #test "should get get_list" do
  #  get :get_list
  #  assert_response :success
  #end

  test "NewUser shouldn't create topic_notification" do
    u = comeAsNewUser
    get :create
    assert_redirected_to '/404'
  end
  
  test "ClubFriend should get create" do
    u = comeAsClubFriend
    assert_difference("TopicNotification.count") do
      post :create, topic_notifications: {((2.to_s).to_sym) => '1', type: 'multiple'}
    end  
  end
  test "ClubFriend should get create two notifications" do
    u = comeAsClubFriend
    c = TopicNotification.count
    assert_no_difference("#{c}") do
      post :create, topic_notifications: {((2.to_s).to_sym) => '1', type: 'multiple'}
    end  
  end
  test "ClubFriend should destroy notification" do
    u = comeAsClubFriend
    c = TopicNotification.count(false)
    post :create, topic_notifications: {((1.to_s).to_sym) => '0', type: 'multiple'}
    assert TopicNotification.count(false) == c - 1, "Не удалось удалить оповещение"
  end
  
  test "ClubPilot should destroy notification" do
    u = comeAsClubPilot
    c = TopicNotification.count(false)
    post :create, topic_notifications: {((1.to_s).to_sym) => '0', type: 'multiple'}
    assert TopicNotification.count(false) == c - 1, "Не удалось удалить оповещение"
  end
  
  test "ClubManager should destroy notification" do
    u = comeAsManager
    c = TopicNotification.count(false)
    post :create, topic_notifications: {((1.to_s).to_sym) => '0', type: 'multiple'}
    assert TopicNotification.count(false) == c - 1, "Не удалось удалить оповещение"
  end
  
  test "Admin should destroy notification" do
    u = comeAsAdmin
    c = TopicNotification.count(false)
    post :create, topic_notifications: {((1.to_s).to_sym) => '0', type: 'multiple'}
    assert TopicNotification.count(false) == c - 1, "Не удалось удалить оповещение"
  end
  
  test "SuperAdmin should destroy notification" do
    u = comeAsSuperAdmin
    c = TopicNotification.count(false)
    post :create, topic_notifications: {((1.to_s).to_sym) => '0', type: 'multiple'}
    assert TopicNotification.count(false) == c - 1, "Не удалось удалить оповещение"
  end
  #test "should get destroy" do
  #  get :destroy
  #  assert_response :success
  #end

end
