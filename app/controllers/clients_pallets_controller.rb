class ClientsPalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_clients_pallet, only: [:show, :edit, :update, :destroy]
  before_action :find_client, only: [:new, :create, :index, :edit]
  load_and_authorize_resource

  respond_to :html

  def index

  end

  def show

  end

  def new
    @clients_pallet = @client.clients_pallets.build
  end

  def edit
  end

  def create
    @client_source = Client.where(cpf_cnpj: params[:client_source_cnpj]).first
    @clients_pallet = ClientsPallet.new(clients_pallet_params)
    @product = Product.where(cod_prod: params[:cod_prod]).first
    @clients_pallet.client_id = @client.id
    @clients_pallet.source_client_id = @client_source.id
    @clients_pallet.product_id = @product.id if @product.present?
    respond_to do |format|
      if @clients_pallet.save
        format.html { redirect_to [@client, @clients_pallet] , flash: { success: "Client Pallets was successfully created." } }
        format.json { render action: 'show', status: :created, location: [@client, @clients_pallet] }
        format.js   { render action: 'show', status: :created, location: [@client, @clients_pallet] }
      else
        format.html { render action: 'new' }
        format.json { render json: @clients_pallet.errors, status: :unprocessable_entity }
        format.js   { render json: @clients_pallet.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      #@client_discharge.updated_user_id = current_user.id
      if @clients_pallet.update(clients_pallet_params)
        format.html { redirect_to [@client, @clients_pallet] , flash: { success: "Client Discharge was successfully updated." } }
        format.json { head :no_content }
        format.js   { render action: 'show', status: :created, location: [@client, @clients_pallet] }
      else
        format.html { render action: 'edit' }
        format.json { render json: @clients_pallet.errors, status: :unprocessable_entity }
        format.js   { render json: @clients_pallet.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @clients_pallet.destroy
    respond_with(@clients_pallet)
  end

  private
    def set_clients_pallet
      find_client
      @clients_pallet = ClientsPallet.find(params[:id])
    end

    def clients_pallet_params
      params.require(:clients_pallet).permit(:client_id, :product_id, :layer_pallet)
    end

    def find_client
      @client  = Client.find(params[:client_id])
    end    
end
