require 'test_helper'

class ClientDischargesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
