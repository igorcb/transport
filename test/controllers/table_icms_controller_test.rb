require 'test_helper'

class TableIcmsControllerTest < ActionController::TestCase
  setup do
    @table_icm = table_icms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:table_icms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create table_icm" do
    assert_difference('TableIcms.count') do
      post :create, table_icm: { aliquot: @table_icm.aliquot, state_source: @table_icm.state_source, state_target: @table_icm.state_target }
    end

    assert_redirected_to table_icm_path(assigns(:table_icm))
  end

  test "should show table_icm" do
    get :show, id: @table_icm
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @table_icm
    assert_response :success
  end

  test "should update table_icm" do
    patch :update, id: @table_icm, table_icm: { aliquot: @table_icm.aliquot, state_source: @table_icm.state_source, state_target: @table_icm.state_target }
    assert_redirected_to table_icm_path(assigns(:table_icm))
  end

  test "should destroy table_icm" do
    assert_difference('TableIcms.count', -1) do
      delete :destroy, id: @table_icm
    end

    assert_redirected_to table_icms_index_path
  end
end
