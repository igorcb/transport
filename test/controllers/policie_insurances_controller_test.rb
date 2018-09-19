require 'test_helper'

class PolicieInsurancesControllerTest < ActionController::TestCase
  setup do
    @policie_insurance = policie_insurances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:policie_insurances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create policie_insurance" do
    assert_difference('PolicieInsurance.count') do
      post :create, policie_insurance: { borker_id: @policie_insurance.borker_id, date_expired: @policie_insurance.date_expired, insurer_id: @policie_insurance.insurer_id, policy: @policie_insurance.policy, proposal: @policie_insurance.proposal, value: @policie_insurance.value }
    end

    assert_redirected_to policie_insurance_path(assigns(:policie_insurance))
  end

  test "should show policie_insurance" do
    get :show, id: @policie_insurance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @policie_insurance
    assert_response :success
  end

  test "should update policie_insurance" do
    patch :update, id: @policie_insurance, policie_insurance: { borker_id: @policie_insurance.borker_id, date_expired: @policie_insurance.date_expired, insurer_id: @policie_insurance.insurer_id, policy: @policie_insurance.policy, proposal: @policie_insurance.proposal, value: @policie_insurance.value }
    assert_redirected_to policie_insurance_path(assigns(:policie_insurance))
  end

  test "should destroy policie_insurance" do
    assert_difference('PolicieInsurance.count', -1) do
      delete :destroy, id: @policie_insurance
    end

    assert_redirected_to policie_insurances_path
  end
end
