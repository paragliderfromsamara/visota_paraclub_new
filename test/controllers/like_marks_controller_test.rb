require 'test_helper'

class LikeMarksControllerTest < ActionController::TestCase
  test "should get switch_mark" do
    get :switch_mark
    assert_response :success
  end

end
