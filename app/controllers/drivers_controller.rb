class DriversController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_driver, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def nome_banco
    bank_id = params[:id].to_i
    # banks = Bank.where(:id => bank_id)
    # bnk = []
    # banks.each do |b|
    #   bnk << {:id => b.id, :nome => b.nome}
    # end
    # render :json => {:bnk => bnk.compact}.as_json  
    bnk = Bank.find(bank_id)
    #render :json => {:bnk => bnk.compact}.as_json  
    render :json => bnk.as_json  
  end

  # GET /drivers
  # GET /drivers.json
  def index
    @drivers = Driver.all
  end

  # GET /drivers/1
  # GET /drivers/1.json
  def show
  end

  # GET /drivers/new
  def new
    @driver = Driver.new
    @driver.contacts.build
    @driver.account_banks.build
    @driver.table_prices.build
    @driver.drivings.build
    #@driver.assets.build
  end

  # GET /drivers/1/edit
  def edit
  end

  # POST /drivers
  # POST /drivers.json
  def create
    @driver = Driver.new(driver_params)

    respond_to do |format|
      if @driver.save
        format.html { redirect_to @driver, flash: { success: "Driver was successfully created." } }
        format.json { render action: 'show', status: :created, location: @driver }
      else
        format.html { render action: 'new' }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drivers/1
  # PATCH/PUT /drivers/1.json
  def update
    respond_to do |format|
      if @driver.update(driver_params)
        format.html { redirect_to @driver, flash: { success: "Driver was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drivers/1
  # DELETE /drivers/1.json
  def destroy
    if @driver.destroy
      respond_to do |format|
        format.html { redirect_to drivers_url }
        format.json { head :no_content }
      end
    else
      flash[:danger] = "The deletion failed because: " + @driver.errors.full_messages.to_sentence
      redirect_to drivers_url
    end
  end

  def get_driver_by_id
    @driver = Driver.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def get_driver_by_cpf
    @driver = Driver.find_by_cpf(params[:cpf_cpnj])
    respond_to do |format|
      format.js
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_driver
      @driver = Driver.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def driver_params
      params.require(:driver).permit(:cpf, :nome, :fantasia, :inscricao_estadual, :instricao_municipal, :endereco, :numero, :complemento, 
        :bairro, :cidade, :estado, :cep, :rg, :data_emissao_rg, :orgao_expeditor, :obs,
        :data_nascimento, :municipio_nascimento, :estado_nascimento, :inss, 
        :cnh, :registro_cnh, :categoria, :validade_cnh, :nome_do_pai, :nome_da_mae, :avatar,
        contacts_attributes: [:contact, :tipo, :nome, :fone, :complemento, :id, :_destroy],
        table_prices_attributes: [:uf_tipo, :tipo, :valor, :id, :_destroy],
        account_banks_attributes: [:banco, :nome_banco, :tipo_operacao, :agencia, :conta_corrente, :favorecido, :cpf_cnpj, :id, :_destroy],
        assets_attributes: [:asset, :id, :_destroy],
        driver_restrictions_attributes: [:client_id, :restriction, :observation, :id, :_destroy],
        drivings_attributes: [:vehicle_id, :id, :_destroy]
        )
    end
end
