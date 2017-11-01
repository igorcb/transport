require 'test_helper'

class RepresentativesControllerTest < ActionController::TestCase
  setup do
    @representative = representatives(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:representatives)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create representative" do
    assert_difference('Representative.count') do
      post :create, representative: { bairro: @representative.bairro, cidade: @representative.cidade, complemento: @representative.complemento, cpf_cnpj: @representative.cpf_cnpj, data_emissao: @representative.data_emissao, endereco: @representative.endereco, estado: @representative.estado, fantasia: @representative.fantasia, inscricao_estadual: @representative.inscricao_estadual, inscricao_municipal: @representative.inscricao_municipal, nome: @representative.nome, numero: @representative.numero, observacao: @representative.observacao, orgao_emissor: @representative.orgao_emissor, rg: @representative.rg, tipo_pessoa: @representative.tipo_pessoa }
    end

    assert_redirected_to representative_path(assigns(:representative))
  end

  test "should show representative" do
    get :show, id: @representative
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @representative
    assert_response :success
  end

  test "should update representative" do
    patch :update, id: @representative, representative: { bairro: @representative.bairro, cidade: @representative.cidade, complemento: @representative.complemento, cpf_cnpj: @representative.cpf_cnpj, data_emissao: @representative.data_emissao, endereco: @representative.endereco, estado: @representative.estado, fantasia: @representative.fantasia, inscricao_estadual: @representative.inscricao_estadual, inscricao_municipal: @representative.inscricao_municipal, nome: @representative.nome, numero: @representative.numero, observacao: @representative.observacao, orgao_emissor: @representative.orgao_emissor, rg: @representative.rg, tipo_pessoa: @representative.tipo_pessoa }
    assert_redirected_to representative_path(assigns(:representative))
  end

  test "should destroy representative" do
    assert_difference('Representative.count', -1) do
      delete :destroy, id: @representative
    end

    assert_redirected_to representatives_path
  end
end
