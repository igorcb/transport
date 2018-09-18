require 'test_helper'

class TableInsurancesControllerTest < ActionController::TestCase
  setup do
    @table_insurance = table_insurances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:table_insurances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create table_insurance" do
    assert_difference('TableInsurance.count') do
      post :create, table_insurance: { insurer_id: @table_insurance.insurer_id, percent: @table_insurance.percent, state_source: @table_insurance.state_source, state_target: @table_insurance.state_target }
    end

    assert_redirected_to table_insurance_path(assigns(:table_insurance))
  end

  test "should show table_insurance" do
    get :show, id: @table_insurance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @table_insurance
    assert_response :success
  end

  test "should update table_insurance" do
    patch :update, id: @table_insurance, table_insurance: { insurer_id: @table_insurance.insurer_id, percent: @table_insurance.percent, state_source: @table_insurance.state_source, state_target: @table_insurance.state_target }
    assert_redirected_to table_insurance_path(assigns(:table_insurance))
  end

  test "should destroy table_insurance" do
    assert_difference('TableInsurance.count', -1) do
      delete :destroy, id: @table_insurance
    end

    assert_redirected_to table_insurances_path
  end
end
