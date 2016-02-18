require 'test_helper'

class OldMessagesControllerTest < ActionController::TestCase
  setup do
    @old_message = old_messages(:oldMessageWithoutUserId)
    @old_message_2 = old_messages(:oldMessageWithoutUserId_2)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:old_messages)
  end

  #test "should get new" do
  #  get :new
  #  assert_response :success
  #end

  #test "should create old_message" do
	
  #  assert_difference('OldMessage.count') do
  #    post :create, :old_message => { :content => @old_message.content, :created_when => @old_message.created_when, :user_id => @old_message.user_id, :user_name => @old_message.user_name }
  #  end

  #  assert_redirected_to old_message_path(assigns(:old_message))
  #end

  #test "should show old_message" do
  #  get :show, :id => @old_message
  #  assert_response :success
  #end

  test "SuperAdmin should get edit" do
	comeAsSuperAdmin
    get :edit, :id => @old_message
    assert_response :success
  end

  test "SuperAdmin should update old_message" do
	comeAsSuperAdmin
    put :update, :id => @old_message, :old_message => { :content => @old_message.content, :created_when => @old_message.created_when, :user_id => @old_message.user_id, :user_name => @old_message.user_name }
    assert_redirected_to old_messages_path
  end

  test "SuperAdmin should destroy old_message" do
	comeAsSuperAdmin
    assert_difference('OldMessage.count', -1) do
      delete :destroy, :id => @old_message
    end

    assert_redirected_to old_messages_path
  end
  
  test "NewUser should't get edit" do
	comeAsNewUser
    get :edit, :id => @old_message_2
    assert_redirected_to '/404'
  end

  test "NewUser should't update old_message" do
	comeAsNewUser
    put :update, :id => @old_message_2, :old_message => { :content => @old_message_2.content, :created_when => @old_message_2.created_when, :user_id => @old_message_2.user_id, :user_name => @old_message_2.user_name }
    assert_redirected_to '/404'
  end

  test "NewUser should't destroy old_message" do
	comeAsNewUser
    assert_no_difference('OldMessage.count', -1) do
      delete :destroy, :id => @old_message_2
    end
    assert_redirected_to '/404'
  end
end
