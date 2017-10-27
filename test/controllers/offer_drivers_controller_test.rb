require 'test_helper'

class OfferDriversControllerTest < ActionController::TestCase
  setup do
    @offer_driver = offer_drivers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:offer_drivers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create offer_driver" do
    assert_difference('OfferDriver.count') do
      post :create, offer_driver: { date_incoming: @offer_driver.date_incoming, driver: @offer_driver.driver, offer_charge_id: @offer_driver.offer_charge_id, place_cart_first: @offer_driver.place_cart_first, place_cart_second: @offer_driver.place_cart_second, place_horse: @offer_driver.place_horse, status: @offer_driver.status, time_incoming: @offer_driver.time_incoming, type_vehicle: @offer_driver.type_vehicle }
    end

    assert_redirected_to offer_driver_path(assigns(:offer_driver))
  end

  test "should show offer_driver" do
    get :show, id: @offer_driver
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @offer_driver
    assert_response :success
  end

  test "should update offer_driver" do
    patch :update, id: @offer_driver, offer_driver: { date_incoming: @offer_driver.date_incoming, driver: @offer_driver.driver, offer_charge_id: @offer_driver.offer_charge_id, place_cart_first: @offer_driver.place_cart_first, place_cart_second: @offer_driver.place_cart_second, place_horse: @offer_driver.place_horse, status: @offer_driver.status, time_incoming: @offer_driver.time_incoming, type_vehicle: @offer_driver.type_vehicle }
    assert_redirected_to offer_driver_path(assigns(:offer_driver))
  end

  test "should destroy offer_driver" do
    assert_difference('OfferDriver.count', -1) do
      delete :destroy, id: @offer_driver
    end

    assert_redirected_to offer_drivers_path
  end
end
