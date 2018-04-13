require 'test_helper'

class ClientTablePricesControllerTest < ActionController::TestCase
  setup do
    @client_table_price = client_table_prices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:client_table_prices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client_table_price" do
    assert_difference('ClientTablePrice.count') do
      post :create, client_table_price: { client_id: @client_table_price.client_id, collection_delivery_ad_icms_value_frete: @client_table_price.collection_delivery_ad_icms_value_frete, collection_delivery_ad_value_minimum: @client_table_price.collection_delivery_ad_value_minimum, collection_delivery_icms_taxpayer: @client_table_price.collection_delivery_icms_taxpayer, collection_delivery_incidence: @client_table_price.collection_delivery_incidence, collection_delivery_non_taxpayer: @client_table_price.collection_delivery_non_taxpayer, freight_dispatch: @client_table_price.freight_dispatch, freight_gris: @client_table_price.freight_gris, freight_toll: @client_table_price.freight_toll, freight_trt: @client_table_price.freight_trt, freight_type_gris: @client_table_price.freight_type_gris, freight_type_trt: @client_table_price.freight_type_trt, freight_value: @client_table_price.freight_value, freight_volume: @client_table_price.freight_volume, freight_weight: @client_table_price.freight_weight, minimum_gris: @client_table_price.minimum_gris, minimum_total_freight: @client_table_price.minimum_total_freight, minimum_trt: @client_table_price.minimum_trt, minimum_value: @client_table_price.minimum_value, minimum_weight_kg: @client_table_price.minimum_weight_kg, minimum_weiht: @client_table_price.minimum_weiht, secure_rate: @client_table_price.secure_rate, secure_rate_aggravated: @client_table_price.secure_rate_aggravated, secure_rate_filch: @client_table_price.secure_rate_filch, type_service_id: @client_table_price.type_service_id, use_aliquot_consumer_last: @client_table_price.use_aliquot_consumer_last, validity_end: @client_table_price.validity_end, validity_start: @client_table_price.validity_start, validity_status: @client_table_price.validity_status }
    end

    assert_redirected_to client_table_price_path(assigns(:client_table_price))
  end

  test "should show client_table_price" do
    get :show, id: @client_table_price
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @client_table_price
    assert_response :success
  end

  test "should update client_table_price" do
    patch :update, id: @client_table_price, client_table_price: { client_id: @client_table_price.client_id, collection_delivery_ad_icms_value_frete: @client_table_price.collection_delivery_ad_icms_value_frete, collection_delivery_ad_value_minimum: @client_table_price.collection_delivery_ad_value_minimum, collection_delivery_icms_taxpayer: @client_table_price.collection_delivery_icms_taxpayer, collection_delivery_incidence: @client_table_price.collection_delivery_incidence, collection_delivery_non_taxpayer: @client_table_price.collection_delivery_non_taxpayer, freight_dispatch: @client_table_price.freight_dispatch, freight_gris: @client_table_price.freight_gris, freight_toll: @client_table_price.freight_toll, freight_trt: @client_table_price.freight_trt, freight_type_gris: @client_table_price.freight_type_gris, freight_type_trt: @client_table_price.freight_type_trt, freight_value: @client_table_price.freight_value, freight_volume: @client_table_price.freight_volume, freight_weight: @client_table_price.freight_weight, minimum_gris: @client_table_price.minimum_gris, minimum_total_freight: @client_table_price.minimum_total_freight, minimum_trt: @client_table_price.minimum_trt, minimum_value: @client_table_price.minimum_value, minimum_weight_kg: @client_table_price.minimum_weight_kg, minimum_weiht: @client_table_price.minimum_weiht, secure_rate: @client_table_price.secure_rate, secure_rate_aggravated: @client_table_price.secure_rate_aggravated, secure_rate_filch: @client_table_price.secure_rate_filch, type_service_id: @client_table_price.type_service_id, use_aliquot_consumer_last: @client_table_price.use_aliquot_consumer_last, validity_end: @client_table_price.validity_end, validity_start: @client_table_price.validity_start, validity_status: @client_table_price.validity_status }
    assert_redirected_to client_table_price_path(assigns(:client_table_price))
  end

  test "should destroy client_table_price" do
    assert_difference('ClientTablePrice.count', -1) do
      delete :destroy, id: @client_table_price
    end

    assert_redirected_to client_table_prices_path
  end
end
