require 'test_helper'

class DirectChargesControllerTest < ActionController::TestCase
  setup do
    @direct_charge = direct_charges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:direct_charges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create direct_charge" do
    assert_difference('DirectCharge.count') do
      post :create, direct_charge: { carrier_id: @direct_charge.carrier_id, date_charge: @direct_charge.date_charge, decimal: @direct_charge.decimal, driver_id: @direct_charge.driver_id, observation: @direct_charge.observation, palletized: @direct_charge.palletized, place: @direct_charge.place, place_cart2: @direct_charge.place_cart2, place_cart: @direct_charge.place_cart, quantity_pallets: @direct_charge.quantity_pallets, source_city_id: @direct_charge.source_city_id, source_state_id: @direct_charge.source_state_id, target_city_id: @direct_charge.target_city_id, target_state_id: @direct_charge.target_state_id, user_id: @direct_charge.user_id, volume: @direct_charge.volume, weight: @direct_charge.weight }
    end

    assert_redirected_to direct_charge_path(assigns(:direct_charge))
  end

  test "should show direct_charge" do
    get :show, id: @direct_charge
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @direct_charge
    assert_response :success
  end

  test "should update direct_charge" do
    patch :update, id: @direct_charge, direct_charge: { carrier_id: @direct_charge.carrier_id, date_charge: @direct_charge.date_charge, decimal: @direct_charge.decimal, driver_id: @direct_charge.driver_id, observation: @direct_charge.observation, palletized: @direct_charge.palletized, place: @direct_charge.place, place_cart2: @direct_charge.place_cart2, place_cart: @direct_charge.place_cart, quantity_pallets: @direct_charge.quantity_pallets, source_city_id: @direct_charge.source_city_id, source_state_id: @direct_charge.source_state_id, target_city_id: @direct_charge.target_city_id, target_state_id: @direct_charge.target_state_id, user_id: @direct_charge.user_id, volume: @direct_charge.volume, weight: @direct_charge.weight }
    assert_redirected_to direct_charge_path(assigns(:direct_charge))
  end

  test "should destroy direct_charge" do
    assert_difference('DirectCharge.count', -1) do
      delete :destroy, id: @direct_charge
    end

    assert_redirected_to direct_charges_path
  end
end
