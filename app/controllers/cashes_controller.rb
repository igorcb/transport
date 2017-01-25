class CashesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_cash, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html

  def index
    @cashes = Cash.all
    respond_with(@cashes)
  end

  def show
    respond_with(@cash)
  end

  def new
    @cash = Cash.new
    respond_with(@cash)
  end

  def edit
  end

  def create
    @cash = Cash.new(cash_params)
    respond_to do |format|
      if @cash.save
        format.html { redirect_to @cash, flash: { success: "Cash was successfully created." } }
        format.json { render action: 'show', status: :created, location: @cash }
      else
        format.html { render action: 'new' }
        format.json { render json: @cash.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @cash.update(cash_params)
        format.html { redirect_to @cash, flash: { success: "Cash was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cash.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cash.destroy
    respond_with(@cash)
  end

  private
    def set_cash
      @cash = Cash.find(params[:id])
    end

    def cash_params
      params.require(:cash).permit(:data, :valor, :tipo, :payment_method_id, :cost_center_id, :sub_cost_center_id, 
        :historico, :sub_cost_center_three_id, :historic_id, :cash_account_id)
    end
end
