class ClientTablePricesController < ApplicationController
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

  private
    def set_client_table_price
      @client_table_price = ClientTablePrice.find(params[:id])
    end

    def client_table_price_params
      params.require(:client_table_price).permit(:client_id, :type_service_id, :stretch_route_id,
        :freight_weight, :freight_value, :freight_volume, :freight_dispatch, :freight_toll, :freight_type_gris, :freight_gris, :freight_type_trt, :freight_trt, 
        :minimum_total_freight, :minimum_weiht, :minimum_value, :minimum_gris, :minimum_trt, :minimum_weight_kg, 
        :collection_delivery_incidence, :collection_delivery_ad_icms_value_frete, :collection_delivery_ad_value_minimum, :collection_delivery_icms_taxpayer, :collection_delivery_non_taxpayer, :collection_delivery_iss, 
        :use_aliquot_consumer_last, :validity_status, :validity_start, :validity_end, :reset,
        :secure_rate, :secure_rate_filch, :secure_rate_aggravated)
    end
end
