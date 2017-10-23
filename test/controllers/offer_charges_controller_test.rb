require 'test_helper'

class OfferChargesControllerTest < ActionController::TestCase
  setup do
    @offer_charge = offer_charges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:offer_charges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create offer_charge" do
    assert_difference('OfferCharge.count') do
      post :create, offer_charge: { city: @offer_charge.city, client: @offer_charge.client, date_schedule: @offer_charge.date_schedule, date_shipment: @offer_charge.date_shipment, local_loading: @offer_charge.local_loading, qtde_pallets: @offer_charge.qtde_pallets, shipper: @offer_charge.shipper, shipping: @offer_charge.shipping, state: @offer_charge.state, state: @offer_charge.state, type_vehicle: @offer_charge.type_vehicle, value_nf: @offer_charge.value_nf, vehicle_detail: @offer_charge.vehicle_detail, vehicle_situation: @offer_charge.vehicle_situation, volume: @offer_charge.volume, weight: @offer_charge.weight }
    end

    assert_redirected_to offer_charge_path(assigns(:offer_charge))
  end

  test "should show offer_charge" do
    get :show, id: @offer_charge
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @offer_charge
    assert_response :success
  end

  test "should update offer_charge" do
    patch :update, id: @offer_charge, offer_charge: { city: @offer_charge.city, client: @offer_charge.client, date_schedule: @offer_charge.date_schedule, date_shipment: @offer_charge.date_shipment, local_loading: @offer_charge.local_loading, qtde_pallets: @offer_charge.qtde_pallets, shipper: @offer_charge.shipper, shipping: @offer_charge.shipping, state: @offer_charge.state, state: @offer_charge.state, type_vehicle: @offer_charge.type_vehicle, value_nf: @offer_charge.value_nf, vehicle_detail: @offer_charge.vehicle_detail, vehicle_situation: @offer_charge.vehicle_situation, volume: @offer_charge.volume, weight: @offer_charge.weight }
    assert_redirected_to offer_charge_path(assigns(:offer_charge))
  end

  test "should destroy offer_charge" do
    assert_difference('OfferCharge.count', -1) do
      delete :destroy, id: @offer_charge
    end

    assert_redirected_to offer_charges_path
  end
end
