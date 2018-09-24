class TableFreightsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_table_freight, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @table_freights = TableFreight.all
    respond_with(@table_freights)
  end

  def show
    respond_with(@table_freight)
  end

  def new
    @table_freight = TableFreight.new
    respond_with(@table_freight)
  end

  def edit
  end

  def create
    @table_freight = TableFreight.new(table_freight_params)
    @table_freight.save
    respond_with(@table_freight)
  end

  def update
    @table_freight.update(table_freight_params)
    respond_with(@table_freight)
  end

  def destroy
    @table_freight.destroy
    respond_with(@table_freight)
  end

  def get_calc_freight_minimum
    @freight_minimum = CalculateLiquidityService.new(params).call
    respond_to do |format|
      format.js
      #format.json { render json: @freight_minimum.errors, status: :unprocessable_entity }
    end    


    #stretch_route = StretchRoute.where(id: params[:trecho_id]).first
    #@freight_minimum = TableFreight.calc_freight_minimum(params[:type_charge_id].to_i, stretch_route.distance.to_i, params[:eixos].to_i)
    # raise "Não foi possivel localizar o trecho" if @stretch.blank?
    # raise "Não foi possivel localizar a Seguradora" if @insurer.blank?
    # raise "Não foi possivel localizar a tabela de icms" if TableIcms.where(state_source: @stretch.stretch_source.estado, state_target: @stretch.stretch_target.estado).blank?
    # raise "Não foi possivel localizar a tabela de frete" if TableFreight.where(type_charge: @type_charge).where("? between km_from and km_to", @stretch.distance).blank?
    # @stretch_route = StretchRoute.includes(:stretch_source, :stretch_target).where(id: params["trecho_id"]).first
    # @insurer = Insurer.where(id: params["insurer_id"]).first
    # @table_insurance = TableInsurance.where(insurer_id: @insurer, state_source: @stretch_route.stretch_source.estado, state_target: @stretch_route.stretch_target.estado).first if @stretch_route.present?
    # @table_icms = TableIcms.where(state_source: @stretch_route.stretch_source.estado, state_target: @stretch_route.stretch_target.estado).first if @stretch_route.present?
    # @table_freight = TableFreight.where(type_charge: @type_charge).where("? between km_from and km_to", @stretch_route.distance).first if @stretch_route.present?

    # respond_to do |format|
    #   if @stretch_route.blank?
    #     format.json { render json: 'Não foi possivel localizar o trecho', status: :unprocessable_entity }
    #   elsif @insurer.blank?
    #     format.json { render json: 'Não foi possivel localizar a Seguradora', status: :unprocessable_entity }
    #   elsif @table_insurance.blank?
    #     format.json { render json: 'Não foi possivel localizar a Apolices da Seguradora', status: :unprocessable_entity }
    #   elsif @table_icms 
    #     format.json { render json: 'Não foi possivel localizar a tabela de icms', status: :unprocessable_entity }
    #   elsif @table_freight.blank?
    #     format.json { render json: 'Não foi possivel localizar a tabela de frete', status: :unprocessable_entity }
    #   else
    #     @freight_minimum = CalculateLiquidityService.new(params).call
    #     format.js
    #     format.json { render json: @freight_minimum.errors, status: :unprocessable_entity }
    #   end
    #end

  end

  private
    def set_table_freight
      @table_freight = TableFreight.find(params[:id])
    end

    def table_freight_params
      params.require(:table_freight).permit(:type_charge, :km_from, :km_to, :price)
    end
end
