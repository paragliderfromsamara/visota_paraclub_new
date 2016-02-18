require 'test_helper'

class StepsControllerTest < ActionController::TestCase
  setup do
    @step = steps(:one)
  end

  test "should get index for super_admin" do
    comeAsSuperAdmin
    get :index
    assert_response :success
    assert_not_nil assigns(:steps)
  end

  test "should't get index for guest" do
    get :index
    assert_redirected_to '/404'
  end 
  test "should't get show for guest" do
    get :show, :id => @step
    assert_redirected_to '/404'
  end 
  
  test "should get show for super_admin" do
    comeAsSuperAdmin
    get :show, :id => @step
    assert_response :success
  end

end
