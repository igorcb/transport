class StretchRoutesController < ApplicationController
  before_action :set_stretch_route, only: [:show, :edit, :update, :destroy]

  respond_to :html, :js

  def index
    @stretch_routes = StretchRoute.all
    respond_with(@stretch_routes)
  end

  def show
    respond_with(@stretch_route)
  end

  def new
    @stretch_route = StretchRoute.new
    respond_with(@stretch_route)
  end

  def edit
  end

  def create
    @stretch_route = StretchRoute.new(stretch_route_params)
    @stretch_route.save
    respond_with(@stretch_route)
  end

  def update
    @stretch_route.update(stretch_route_params)
    respond_with(@stretch_route)
  end

  def destroy
    @stretch_route.destroy
    respond_with(@stretch_route)
  end

  def get_stretch_routes_from_client_cnpj
    client = Client.where(cpf_cnpj: params[:cpf_cnpj]).first
    stretchs = StretchRoute.includes(:stretch_source, :stretch_target).where(id: client.client_table_prices.select(:stretch_route_id).uniq.pluck(:stretch_route_id))
    @stretch_routes = stretchs.map {|c| [c.stretch_source_and_target_long, c.id] }.insert(0, 'SELECIONE O TRECHO')
  end

  def get_stretch_route_by_id
    @stretch_route = StretchRoute.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def get_stretch_route_by_state
    @stretch_routes = StretchRoute.state_source(params[:state].to_s)
    stretch_array = []
    @stretch_routes.each do |s|
      stretch_array << {:id => s.id, :n => s.stretch_source_and_target_short}
    end
    render :text => stretch_array.to_json.force_encoding("UTF-8")    
  end

  def get_stretch_route_by_state_source_ant_target
    @stretch_routes = StretchRoute.state_source_and_target(params[:state_source].to_s, params[:state_target].to_s)
    stretch_array = []
    @stretch_routes.each do |s|
      stretch_array << {:id => s.id, :n => s.stretch_source_and_target_short}
    end
    render :text => stretch_array.to_json.force_encoding("UTF-8")    
  end

  private
    def set_stretch_route
      @stretch_route = StretchRoute.where(id: params[:id]).first
    end

    def stretch_route_params
      params.require(:stretch_route).permit(:stretch_source_id, :stretch_target_id, :tax_rate, :non_tax_rate, :secure_rate, 
        :secure_rate_filch, :secure_rate_aggravated, :travel_time, :distance, :cost_kg, :tax_iss, :pis_cofins)
    end
end
