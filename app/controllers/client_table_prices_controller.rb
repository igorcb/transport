class ClientTablePricesController < ApplicationController
  include OrdemServiceHelper
  before_filter :authenticate_user!
  
  before_action :set_client_table_price, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @client_table_prices = ClientTablePrice.all
    respond_with(@client_table_prices)
  end

  def show
    respond_with(@client_table_price)
  end

  def new
    @client_table_price = ClientTablePrice.new
    respond_with(@client_table_price)
  end

  def edit
  end

  def create
    @client_table_price = ClientTablePrice.new(client_table_price_params)
    @client_table_price.save
    respond_with(@client_table_price)
  end

  def update
    @client_table_price.update(client_table_price_params)
    respond_with(@client_table_price)
  end

  def destroy
    @client_table_price.destroy
    respond_with(@client_table_price)
  end

  def get_client_table_price_of_client
    #client_table_prices = ClientTablePrice.stretch_of_client.where(client_id: params[:client_id])
    client_table_prices = table_price_of_billing_client(params[:client_id])
    client_table_prices
    array = []
    client_table_prices.each do |c|
      array << {:client_table_price_id => c.id, :n => c.trecho}
    end
    render :text => array.to_json
  end    

  def get_client_table_price_of_client_service
    puts ">>>>>>>>>>>>>>>>>>>>> get_client_table_price_of_client_service <<<<<<<<<<<<<<<<<<<<<<<<<<"
    client_table_price = ClientTablePrice.where(id: params[:client_id])
    array = []
    client_table_price.each do |c|
      array << {:id => c.type_service.id, :n => c.type_service.descricao}
    end
    render :text => array.to_json
  end    

  def get_client_table_price_of_by_cnpj
    puts ">>>>>>>>>>>>>>>>>>>>> get_client_table_price_of_client_service_cnpj <<<<<<<<<<<<<<<<<<<<<<<<<<"
    client = Client.where(cpf_cnpj: params[:cpf_cnpj]).first
    array = []
    client.client_table_prices.each do |c|
      array << {:id => c.type_service.id, :n => c.type_service.descricao}
    end
    render :text => array.to_json
  end

  private
    def set_client_table_price
      @client_table_price = ClientTablePrice.find(params[:id])
    end

    def client_table_price_params
      params.require(:client_table_price).permit(:client_id, :type_service_id, :stretch_route_id, :type_calc,
        :freight_weight, :freight_value, :freight_volume, :freight_dispatch, :freight_toll, :freight_type_gris, :freight_gris, :freight_type_trt, :freight_trt, :payment_discharges, :margin_lucre,
        :minimum_total_freight, :minimum_weiht, :minimum_value, :minimum_gris, :minimum_trt, :minimum_weight_kg, 
        :collection_delivery_incidence, :collection_delivery_ad_icms_value_frete, :collection_delivery_ad_value_minimum, :collection_delivery_icms_taxpayer, :collection_delivery_non_taxpayer, :collection_delivery_iss, 
        :use_aliquot_consumer_last, :validity_status, :validity_start, :validity_end, :reset,
        :secure_rate, :secure_rate_filch, :secure_rate_aggravated)
    end
end
