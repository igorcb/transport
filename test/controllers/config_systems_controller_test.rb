require 'test_helper'

class ConfigSystemsControllerTest < ActionController::TestCase
  setup do
    @config_system = config_systems(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:config_systems)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create config_system" do
    assert_difference('ConfigSystem.count') do
      post :create, config_system: { config_description: @config_system.config_description, config_key: @config_system.config_key, config_value: @config_system.config_value }
    end

    assert_redirected_to config_system_path(assigns(:config_system))
  end

  test "should show config_system" do
    get :show, id: @config_system
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @config_system
    assert_response :success
  end

  test "should update config_system" do
    patch :update, id: @config_system, config_system: { config_description: @config_system.config_description, config_key: @config_system.config_key, config_value: @config_system.config_value }
    assert_redirected_to config_system_path(assigns(:config_system))
  end

  test "should destroy config_system" do
    assert_difference('ConfigSystem.count', -1) do
      delete :destroy, id: @config_system
    end

    assert_redirected_to config_systems_path
  end
end
