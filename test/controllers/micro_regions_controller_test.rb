require 'test_helper'

class MicroRegionsControllerTest < ActionController::TestCase
  setup do
    @micro_region = micro_regions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:micro_regions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create micro_region" do
    assert_difference('MicroRegion.count') do
      post :create, micro_region: { name: @micro_region.name }
    end

    assert_redirected_to micro_region_path(assigns(:micro_region))
  end

  test "should show micro_region" do
    get :show, id: @micro_region
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @micro_region
    assert_response :success
  end

  test "should update micro_region" do
    patch :update, id: @micro_region, micro_region: { name: @micro_region.name }
    assert_redirected_to micro_region_path(assigns(:micro_region))
  end

  test "should destroy micro_region" do
    assert_difference('MicroRegion.count', -1) do
      delete :destroy, id: @micro_region
    end

    assert_redirected_to micro_regions_path
  end
end
