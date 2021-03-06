class ClientTablePricesController < ApplicationController
  include OrdemServiceHelper
  before_action :authenticate_user!
  before_action :set_client_table_price, only: [:show, :edit, :update, :destroy]
  before_action :find_client, only: [:new, :create, :index, :edit]

  respond_to :html

  def index

  end

  def show

  end

  def new
    @client_table_price = ClientTablePrice.new
    respond_with(@client_table_price)
  end

  def edit
  end

  def create
    @client_table_price = @client.client_table_prices.build(client_table_price_params)
    respond_to do |format|
      if @client_table_price.save
        format.html { redirect_to [@client, @client_table_price] , flash: { success: "Client Table Price was successfully created." } }
        format.json { render action: 'show', status: :created, location: [@client, @client_table_price] }
        format.js   { render action: 'show', status: :created, location: [@client, @client_table_price] }
      else
        format.html { render action: 'new' }
        format.json { render json: @client_table_price.errors, status: :unprocessable_entity }
        format.js   { render json: @client_table_price.errors, status: :unprocessable_entity }
      end
    end    
  end

  def update
    respond_to do |format|
      if @client_table_price.update(client_table_price_params)
        format.html { redirect_to [@client, @client_table_price] , flash: { success: "Client Table Price was successfully updated." } }
        format.json { head :no_content }
        format.js   { render action: 'show', status: :created, location: [@client, @client_table_price] }
      else
        format.html { render action: 'edit' }
        format.json { render json: @client_table_price.errors, status: :unprocessable_entity }
        format.js   { render json: @client_table_price.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @client_table_price.destroy
    respond_with(@client_table_price)
  end

  def get_client_table_price_of_client
    #client_table_prices = ClientTablePrice.stretch_of_client.where(client_id: params[:client_id])
    client_table_prices = table_price_of_billing_client(params[:client_id])
    array = []
    client_table_prices.each do |c|
      array << {:client_table_price_id => c.id, :n => c.trecho}
    end
    render :text => array.to_json
  end    

  def get_client_table_price_of_client_service
    client_table_price = ClientTablePrice.where(id: params[:client_id])
    array = []
    client_table_price.each do |c|
      array << {:id => c.type_service.id, :n => c.type_service.descricao}
    end
    render :text => array.to_json
  end    

  def get_client_table_price_of_by_client_cnpj_and_stretch_route
    # array = []
    # client_table_prices.each do |c|
    #   array << {:id => c.type_service.id, :n => c.type_service.descricao}
    # end
    # render :text => array.to_json

    client = Client.where(cpf_cnpj: params[:cpf_cnpj]).first
    client_table_prices = ClientTablePrice.includes(:stretch_route).where(client_table_price_id: client.id, stretch_route_id: params[:stretch_route_id])
    @client_table_prices = client_table_prices.map {|c| [c.type_service.descricao, c.type_service.id] }.insert(0, 'SELECIONE O SERVICO')
  end

  private
    def set_client_table_price
      find_client     
      @client_table_price = @client.client_table_prices.where(id: params[:id]).first
    end

    def client_table_price_params
      params.require(:client_table_price).permit(:client_id, :type_service_id, :stretch_route_id, :type_calc,
        :freight_weight, :freight_value, :freight_volume, :freight_dispatch, :freight_toll, :freight_type_gris, :freight_gris, :freight_type_trt, :freight_trt, :payment_discharges, :margin_lucre,
        :minimum_total_freight, :minimum_weiht, :minimum_value, :minimum_gris, :minimum_trt, :minimum_weight_kg, 
        :collection_delivery_incidence, :collection_delivery_ad_icms_value_frete, :collection_delivery_ad_value_minimum, :collection_delivery_icms_taxpayer, :collection_delivery_non_taxpayer, :collection_delivery_iss, 
        :use_aliquot_consumer_last, :validity_status, :validity_start, :validity_end, :reset,
        :secure_rate, :secure_rate_filch, :secure_rate_aggravated)
    end

    def find_client
      if params[:client_id].present?
        @client  = Client.find(params[:client_id])
      else
        @client  = Carrier.find(params[:carrier_id])
      end
    end    
end
