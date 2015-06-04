require 'test_helper'

class ThemeNotificationsControllerTest < ActionController::TestCase
  test "should get get_list" do
    get :get_list
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

end
