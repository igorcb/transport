class ClientsController < ApplicationController
#redirect_to select_client_path, :flash => { :danger => "Informe o valor da parcela" } 
#flash[:success] = "Parcela foi atualizada com sucesso."
  
  before_filter :authenticate_user!
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html, :js

  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all
    @q = Client.where(id: -1).search(params[:query])
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
  end

  # GET /clients/new
  def new
    @client = Client.new
    @client.contacts.build
    @client.emails.build
    @client.assets.build 
    @client.account_banks.build
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)
    @client.user_created_id = current_user.id
    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, flash: { success: "Client was successfully created." } }
        format.json { render action: 'show', status: :created, location: @client }
      else
        format.html { render action: 'new' }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      @client.user_updated_id = current_user.id
      if @client.update(client_params)
        format.html { redirect_to @client, flash: { success: 'Client was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    if @client.destroy
      respond_to do |format|
        format.html { redirect_to clients_url }
        format.json { head :no_content }
      end
    else
      flash[:danger] = "The deletion failed because: " + @client.errors.full_messages.to_sentence
      redirect_to clients_url
    end
  end

  def search
    @q = Client.search(params[:query])
    @clients = @q.result
    respond_with(@clients) do |format|
     format.js
    end  
  end

  def get_client_by_cnpj
    @client = Client.find_by_cpf_cnpj(params[:cpf_cpnj])
    respond_to do |format|
      format.js
    end
  end

  def get_client_by_id
    @client = Client.find(params[:id])
    respond_to do |format|
      format.js
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:cpf_cnpj, :nome, :fantasia, :inscricao_estadual, :inscricao_municipal, :endereco, :numero, :complemento, 
      :bairro, :cidade, :estado, :cep, :tipo_pessoa, :rg, :orgao_emissor, :data_emissao_rg, :obs, :hora_descarga, :condicao_recebimento, :group_client_id,
      :valor_volume, :valor_peso, :faturar, :capital, :faturar_cada, :vencimento_para, :qtde_parcela, :valor_peso_1500, :suframa,
      :orgao_publico, :icms_contribuinte, :tipo_cliente, :accept_operational, :client_credential_sefaz,
      :default_height_maximum_pallet, :type_height_maximum_pallet,
      client_representatives_attributes: [:representative_id, :id, :_destroy],
      contacts_attributes: [:contact, :tipo, :nome, :fone, :complemento, :id, :_destroy],
      emails_attributes: [:sector_id, :setor, :contato, :email, :responsavel_carga, :comprovante, :id, :_destroy],
      account_banks_attributes: [:banco, :nome_banco, :tipo_operacao, :agencia, :conta_corrente, :favorecido, :cpf_cnpj, :id, :_destroy],
      assets_attributes: [:asset, :id, :_destroy]
      )
            

    end
end
