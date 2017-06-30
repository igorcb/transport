require 'test_helper'

class ControlPalletInternalsControllerTest < ActionController::TestCase
  setup do
    @control_pallet_internal = control_pallet_internals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:control_pallet_internals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create control_pallet_internal" do
    assert_difference('ControlPalletInternal.count') do
      post :create, control_pallet_internal: { date_launche: @control_pallet_internal.date_launche, historic: @control_pallet_internal.historic, observation: @control_pallet_internal.observation, qtde: @control_pallet_internal.qtde, responsable_id: @control_pallet_internal.responsable_id, responsable_type: @control_pallet_internal.responsable_type, type_launche: @control_pallet_internal.type_launche }
    end

    assert_redirected_to control_pallet_internal_path(assigns(:control_pallet_internal))
  end

  test "should show control_pallet_internal" do
    get :show, id: @control_pallet_internal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @control_pallet_internal
    assert_response :success
  end

  test "should update control_pallet_internal" do
    patch :update, id: @control_pallet_internal, control_pallet_internal: { date_launche: @control_pallet_internal.date_launche, historic: @control_pallet_internal.historic, observation: @control_pallet_internal.observation, qtde: @control_pallet_internal.qtde, responsable_id: @control_pallet_internal.responsable_id, responsable_type: @control_pallet_internal.responsable_type, type_launche: @control_pallet_internal.type_launche }
    assert_redirected_to control_pallet_internal_path(assigns(:control_pallet_internal))
  end

  test "should destroy control_pallet_internal" do
    assert_difference('ControlPalletInternal.count', -1) do
      delete :destroy, id: @control_pallet_internal
    end

    assert_redirected_to control_pallet_internals_path
  end
end
