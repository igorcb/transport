class RepresentativesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_representative, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  def index
    @representatives = Representative.all
    respond_with(@representatives)
  end

  def show
    respond_with(@representative)
  end

  def new
    @representative = Representative.new
    respond_with(@representative)
  end

  def edit
  end

  def create
    @representative = Representative.new(representative_params)
    @representative.save
    respond_with(@representative)
  end

  def update
    @representative.update(representative_params)
    respond_with(@representative)
  end

  def destroy
    @representative.destroy
    respond_with(@representative)
  end

  private
    def set_representative
      @representative = Representative.find(params[:id])
    end

    def representative_params
      params.require(:representative).permit(:tipo_pessoa, :cpf_cnpj, :nome, :fantasia, :inscricao_estadual, :inscricao_municipal, :endereco, :numero, :complemento, :bairro, :cep, :cidade, :estado, :rg, :orgao_emissor, :data_emissao, :observacao)
    end
end
