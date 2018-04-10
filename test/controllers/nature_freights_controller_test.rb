require 'test_helper'

class NatureFreightsControllerTest < ActionController::TestCase
  setup do
    @nature_freight = nature_freights(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nature_freights)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nature_freight" do
    assert_difference('NatureFreight.count') do
      post :create, nature_freight: { name: @nature_freight.name }
    end

    assert_redirected_to nature_freight_path(assigns(:nature_freight))
  end

  test "should show nature_freight" do
    get :show, id: @nature_freight
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nature_freight
    assert_response :success
  end

  test "should update nature_freight" do
    patch :update, id: @nature_freight, nature_freight: { name: @nature_freight.name }
    assert_redirected_to nature_freight_path(assigns(:nature_freight))
  end

  test "should destroy nature_freight" do
    assert_difference('NatureFreight.count', -1) do
      delete :destroy, id: @nature_freight
    end

    assert_redirected_to nature_freights_path
  end
end
