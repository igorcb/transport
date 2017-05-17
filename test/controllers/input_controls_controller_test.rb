require 'test_helper'

class InputControlsControllerTest < ActionController::TestCase
  setup do
    @input_control = input_controls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:input_controls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create input_control" do
    assert_difference('InputControl.count') do
      post :create, input_control: { carrier_id: @input_control.carrier_id, date_entry: @input_control.date_entry, date_receipt: @input_control.date_receipt, driver_id: @input_control.driver_id, observation: @input_control.observation, time_entry: @input_control.time_entry, valor_total: @input_control.valor_total, value_kg: @input_control.value_kg, value_ton: @input_control.value_ton }
    end

    assert_redirected_to input_control_path(assigns(:input_control))
  end

  test "should show input_control" do
    get :show, id: @input_control
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @input_control
    assert_response :success
  end

  test "should update input_control" do
    patch :update, id: @input_control, input_control: { carrier_id: @input_control.carrier_id, date_entry: @input_control.date_entry, date_receipt: @input_control.date_receipt, driver_id: @input_control.driver_id, observation: @input_control.observation, time_entry: @input_control.time_entry, valor_total: @input_control.valor_total, value_kg: @input_control.value_kg, value_ton: @input_control.value_ton }
    assert_redirected_to input_control_path(assigns(:input_control))
  end

  test "should destroy input_control" do
    assert_difference('InputControl.count', -1) do
      delete :destroy, id: @input_control
    end

    assert_redirected_to input_controls_path
  end
end
