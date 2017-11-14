require 'test_helper'

class CteKeysControllerTest < ActionController::TestCase
  test "should get request_cancellation" do
    get :request_cancellation
    assert_response :success
  end

end
