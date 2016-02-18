require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @super_admin = users(:super_admin)
	@admin = users(:admin)
	@club_pilot = users(:club_pilot)
	@club_friend = users(:club_friend)
	@new_user = users(:new_user)
	@bunned = users(:bunned)
	@manager = users(:manager)
	@deleted = users(:deleted)

  end

  test "Should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "Should let to go unsigned user to sign up page" do
	get :new
    assert_response :success
  end

  test "Shouldn't let to go signed user to sign up page" do
	user = comeAsNewUser
	get :new
    assert_redirected_to user_path(user)# assert_response :success#
  end
  
  test "Should create user" do
	u = User.all.last.id + 1
    assert_difference('User.count') do
      post :create, :abi => {:value => 'tU560m', :name => 'xYp89n'}, :user => { :avatar => '', :cell_phone => @new_user.cell_phone, :email => @new_user.name + u.to_s + "@visota-paraclub.ru", :email_status => @new_user.email_status, :password => '123456', :full_name => @new_user.full_name,  :inform => @new_user.inform, :name => @new_user.name + u.to_s, :photo => '', :password_confirmation => '123456', :skype => @new_user.skype, :user_group_id => @new_user.user_group_id }
    end
    assert_redirected_to user_path(u)
  end

  test "should show user" do
    get :show, :id => @new_user
    assert_response :success
  end

  test "should get edit" do
    cookies.permanent.signed[:remember_token] = [@new_user.id, @new_user.salt]
    get :edit, :id => @new_user
    assert_response :success
  end

  test "User should update self" do
    cookies.permanent.signed[:remember_token] = [@new_user.id, @new_user.salt]
	put :update, :id => @new_user, :user => { :cell_phone => @new_user.cell_phone, 
											  :full_name => @new_user.full_name, 
											  :inform => @new_user.inform, 
											  :name => @new_user.name, 
											  :skype => "newSkype"
											}
    assert_redirected_to user_path(assigns(:user))
  end
  
  test "User shouldn't update another user" do
    cookies.permanent.signed[:remember_token] = [@club_pilot.id, @club_pilot.salt]
	put :update, :id => @new_user, :user => { :cell_phone => @new_user.cell_phone, 
											  :full_name => @new_user.full_name, 
											  :inform => @new_user.inform, 
											  :name => @new_user.name, 
											  :skype => "newSkype"
											}
    assert_redirected_to '/404'
  end

  test "should destroy user" do
	cookies.permanent.signed[:remember_token] = [@super_admin.id, @super_admin.salt]
    assert_difference('User.count', -1) do
      delete :destroy, :id => @new_user
    end

    assert_redirected_to users_path
  end
  
  test "shouldn't destroy another user" do
	cookies.permanent.signed[:remember_token] = [@club_friend.id, @club_friend.salt]
    assert_difference('User.count', -1) do
      delete :destroy, :id => @new_user
    end

    assert_redirected_to '/404'
  end
  
  test "shouldn't destroy self" do
	cookies.permanent.signed[:remember_token] = [@club_friend.id, @club_friend.salt]
    assert_difference('User.count', -1) do
      delete :destroy, :id => @club_friend
    end

    assert_redirected_to '/404'
  end
end
