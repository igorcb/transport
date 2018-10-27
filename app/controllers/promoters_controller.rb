class PromotersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_promoter, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @promoters = Promoter.all
    respond_with(@promoters)
  end

  def show
    respond_with(@promoter)
  end

  def new
    @promoter = Promoter.new
    respond_with(@promoter)
  end

  def edit
  end

  def create
    @promoter = Promoter.new(promoter_params)
    respond_to do |format|
      if @promoter.save
        format.html { redirect_to @promoter, flash: { success: "Supplier was successfully created." } }
        format.json { render action: 'show', status: :created, location: @promoter }
      else
        format.html { render action: 'new' }
        format.json { render json: @promoter.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @promoter.update(supplier_params)
        format.html { redirect_to @promoter, flash: { success: "Supplier was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @promoter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @promoter.destroy
    respond_with(@promoter)
  end

  private
    def set_promoter
      @promoter = Promoter.find(params[:id])
    end

    def promoter_params
      params.require(:promoter).permit(:cpf, :nome, :fantasia, :endereco, :numero, :complemento, :bairro, :cidade, :estado, :cep,
        contacts_attributes: [:contact, :tipo, :nome, :fone, :complemento, :id, :_destroy],
        account_banks_attributes: [:banco, :nome_banco, :tipo_operacao, :agencia, :conta_corrente, :favorecido, :cpf_cnpj, :id, :_destroy],
        assets_attributes: [:asset, :id, :_destroy]

        )
    end
end
