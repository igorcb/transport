require 'test_helper'

class StretchRoutesControllerTest < ActionController::TestCase
  setup do
    @stretch_route = stretch_routes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stretch_routes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stretch_route" do
    assert_difference('StretchRoute.count') do
      post :create, stretch_route: { cost_kg: @stretch_route.cost_kg, distance: @stretch_route.distance, non_tax_rate: @stretch_route.non_tax_rate, secure_rate: @stretch_route.secure_rate, secure_rate_aggravated: @stretch_route.secure_rate_aggravated, secure_rate_filch: @stretch_route.secure_rate_filch, streatch_target_id: @stretch_route.streatch_target_id, stretch_source_id: @stretch_route.stretch_source_id, tax_iss: @stretch_route.tax_iss, tax_rate: @stretch_route.tax_rate, travel_time: @stretch_route.travel_time }
    end

    assert_redirected_to stretch_route_path(assigns(:stretch_route))
  end

  test "should show stretch_route" do
    get :show, id: @stretch_route
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stretch_route
    assert_response :success
  end

  test "should update stretch_route" do
    patch :update, id: @stretch_route, stretch_route: { cost_kg: @stretch_route.cost_kg, distance: @stretch_route.distance, non_tax_rate: @stretch_route.non_tax_rate, secure_rate: @stretch_route.secure_rate, secure_rate_aggravated: @stretch_route.secure_rate_aggravated, secure_rate_filch: @stretch_route.secure_rate_filch, streatch_target_id: @stretch_route.streatch_target_id, stretch_source_id: @stretch_route.stretch_source_id, tax_iss: @stretch_route.tax_iss, tax_rate: @stretch_route.tax_rate, travel_time: @stretch_route.travel_time }
    assert_redirected_to stretch_route_path(assigns(:stretch_route))
  end

  test "should destroy stretch_route" do
    assert_difference('StretchRoute.count', -1) do
      delete :destroy, id: @stretch_route
    end

    assert_redirected_to stretch_routes_path
  end
end
