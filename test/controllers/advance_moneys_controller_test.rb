require 'test_helper'

class AdvanceMoneysControllerTest < ActionController::TestCase
  setup do
    @advance_money = advance_moneys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:advance_moneys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create advance_money" do
    assert_difference('AdvanceMoney.count') do
      post :create, advance_money: { date_advance: @advance_money.date_advance, number: @advance_money.number, price: @advance_money.price }
    end

    assert_redirected_to advance_money_path(assigns(:advance_money))
  end

  test "should show advance_money" do
    get :show, id: @advance_money
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @advance_money
    assert_response :success
  end

  test "should update advance_money" do
    patch :update, id: @advance_money, advance_money: { date_advance: @advance_money.date_advance, number: @advance_money.number, price: @advance_money.price }
    assert_redirected_to advance_money_path(assigns(:advance_money))
  end

  test "should destroy advance_money" do
    assert_difference('AdvanceMoney.count', -1) do
      delete :destroy, id: @advance_money
    end

    assert_redirected_to advance_moneys_path
  end
end
