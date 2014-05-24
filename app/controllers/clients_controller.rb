class ClientsController < ApplicationController
#redirect_to select_client_path, :flash => { :danger => "Informe o valor da parcela" } 
#flash[:success] = "Parcela foi atualizada com sucesso."
  
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all
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
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)
    

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
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url }
      format.json { head :no_content }
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
      :bairro, :cidade, :estado, :cep, :tipo_pessoa, :rg, :orgao_emissor, :data_emissao_rg,
      contacts_attributes: [:contact, :tipo, :nome, :fone, :complemento, :id, :_destroy],
      emails_attributes: [:setor, :contato, :email, :id, :_destroy],
      assets_attributes: [:asset, :id, :_destroy]
      )
            

    end
end