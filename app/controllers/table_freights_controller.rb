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

  def calculate_liquidity #show get_calc_freight_minimum
    @company = Company.first
    @freight_minimum = CalculateLiquidityService.new(params[:value]).call #return Hash:[:input, :output]
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "calculate_liquidity",
        #template: "table_freights/calculate_liquidity.html.erb",
        layout: 'pdf.html'
      end
    end
  end

  def get_calc_freight_minimum
    @freight_minimums = CalculateLiquidityService.new(params).call #return Hash:[:input, :output]
    respond_to do |format|
      format.js
    end    
  end

  private
    def set_table_freight
      @table_freight = TableFreight.find(params[:id])
    end

    def table_freight_params
      params.require(:table_freight).permit(:type_charge, :km_from, :km_to, :price)
    end
end
