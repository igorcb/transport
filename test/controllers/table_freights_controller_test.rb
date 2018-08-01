require 'test_helper'

class TableFreightsControllerTest < ActionController::TestCase
  setup do
    @table_freight = table_freights(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:table_freights)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create table_freight" do
    assert_difference('TableFreight.count') do
      post :create, table_freight: { km_from: @table_freight.km_from, km_to: @table_freight.km_to, price: @table_freight.price, type_charge: @table_freight.type_charge }
    end

    assert_redirected_to table_freight_path(assigns(:table_freight))
  end

  test "should show table_freight" do
    get :show, id: @table_freight
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @table_freight
    assert_response :success
  end

  test "should update table_freight" do
    patch :update, id: @table_freight, table_freight: { km_from: @table_freight.km_from, km_to: @table_freight.km_to, price: @table_freight.price, type_charge: @table_freight.type_charge }
    assert_redirected_to table_freight_path(assigns(:table_freight))
  end

  test "should destroy table_freight" do
    assert_difference('TableFreight.count', -1) do
      delete :destroy, id: @table_freight
    end

    assert_redirected_to table_freights_path
  end
end
