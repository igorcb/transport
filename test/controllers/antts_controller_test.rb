require 'test_helper'

class AnttsControllerTest < ActionController::TestCase
  setup do
    @antt = antts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:antts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create antt" do
    assert_difference('Antt.count') do
      post :create, antt: { cpf_cnpj: @antt.cpf_cnpj, date_expiration: @antt.date_expiration, nome: @antt.nome, rntrc: @antt.rntrc }
    end

    assert_redirected_to antt_path(assigns(:antt))
  end

  test "should show antt" do
    get :show, id: @antt
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @antt
    assert_response :success
  end

  test "should update antt" do
    patch :update, id: @antt, antt: { cpf_cnpj: @antt.cpf_cnpj, date_expiration: @antt.date_expiration, nome: @antt.nome, rntrc: @antt.rntrc }
    assert_redirected_to antt_path(assigns(:antt))
  end

  test "should destroy antt" do
    assert_difference('Antt.count', -1) do
      delete :destroy, id: @antt
    end

    assert_redirected_to antts_path
  end
end
