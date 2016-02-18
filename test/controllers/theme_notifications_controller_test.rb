require 'test_helper'

class ThemeNotificationsControllerTest < ActionController::TestCase
  #test "should get get_list" do
  #  get :get_list
  #  assert_response :success
  #end
  setup do
    @theme_ntf_test = themes(:themeForNotificationsTest)
  end
  test "guest sholdn't create theme_notification" do
    comeAsGuest
    assert_no_difference("ThemeNotification.count", 'Удалось подписаться на тему') do
      post :create, theme_notifications: {type: 'single', theme_id: @theme_ntf_test.id}
    end
    assert_redirected_to '/404', "Гостю удалось зайти на страницу добавления подписки на тему"
  end
  
  test "should can make single notification for theme" do
    comeAsNewUser
    assert_difference("ThemeNotification.count", 1, 'Не удалось подписаться на тему') do
      post :create, format: 'json', theme_notifications: {type: 'single', theme_id: @theme_ntf_test.id}
    end
    assert_response :success
  end

  test "should can remove single notification for theme" do
    comeAsClubPilot
    assert_difference("ThemeNotification.count", -1, 'Не удалось отписаться от темы') do
      post :create, format: 'json', theme_notifications: {type: 'single', theme_id: @theme_ntf_test.id}
    end
    assert_response :success
  end
  
  #test "should get destroy" do
  #  get :destroy
  #  assert_response :success
  #end

end
