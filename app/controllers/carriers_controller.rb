class CarriersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_carrier, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /carriers
  # GET /carriers.json
  def index
    @carriers = Carrier.all
  end

  # GET /carriers/1
  # GET /carriers/1.json
  def show
  end

  # GET /carriers/new
  def new
    @carrier = Carrier.new
    @carrier.contacts.build
  end

  # GET /carriers/1/edit
  def edit
  end

  # POST /carriers
  # POST /carriers.json
  def create
    @carrier = Carrier.new(carrier_params)

    respond_to do |format|
      if @carrier.save
        format.html { redirect_to @carrier, flash: { success: "Carrier was successfully created." } }
        format.json { render action: 'show', status: :created, location: @carrier }
      else
        format.html { render action: 'new' }
        format.json { render json: @carrier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carriers/1
  # PATCH/PUT /carriers/1.json
  def update
    respond_to do |format|
      if @carrier.update(carrier_params)
        format.html { redirect_to @carrier, flash: { success: "Carrier was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @carrier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carriers/1
  # DELETE /carriers/1.json
  def destroy
    @carrier.destroy
    respond_to do |format|
      format.html { redirect_to carriers_url }
      format.json { head :no_content }
    end
  end

  def get_carrier_by_id
    @carrier = Carrier.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_carrier
      @carrier = Carrier.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def carrier_params
      params.require(:carrier).permit(:cnpj, :nome, :fantasia, :inscricao_estadual, :inscricao_municipal, :endereco, :numero, :complemento, :bairro, 
      :cidade, :estado, :cep, :obs, :partner, :aereo, :antt, :antt_categoria,
      emails_attributes: [:setor, :contato, :email, :comprovante, :responsavel_carga, :id, :_destroy],
      contacts_attributes: [:contact, :tipo, :nome, :fone, :complemento, :id, :_destroy],
      account_banks_attributes: [:banco, :nome_banco, :tipo_operacao, :agencia, :conta_corrente, :favorecido, :cpf_cnpj, :id, :_destroy],
      assets_attributes: [:asset, :id, :_destroy]
      )
        
    end
end
