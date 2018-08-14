require 'test_helper'

class ClientsPalletsControllerTest < ActionController::TestCase
  setup do
    @clients_pallet = clients_pallets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clients_pallets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create clients_pallet" do
    assert_difference('ClientsPallet.count') do
      post :create, clients_pallet: { client_id: @clients_pallet.client_id, layer_pallet: @clients_pallet.layer_pallet, product_id: @clients_pallet.product_id }
    end

    assert_redirected_to clients_pallet_path(assigns(:clients_pallet))
  end

  test "should show clients_pallet" do
    get :show, id: @clients_pallet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @clients_pallet
    assert_response :success
  end

  test "should update clients_pallet" do
    patch :update, id: @clients_pallet, clients_pallet: { client_id: @clients_pallet.client_id, layer_pallet: @clients_pallet.layer_pallet, product_id: @clients_pallet.product_id }
    assert_redirected_to clients_pallet_path(assigns(:clients_pallet))
  end

  test "should destroy clients_pallet" do
    assert_difference('ClientsPallet.count', -1) do
      delete :destroy, id: @clients_pallet
    end

    assert_redirected_to clients_pallets_path
  end
end
