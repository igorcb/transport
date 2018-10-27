class AdvanceMoneysController < ApplicationController
  before_action :authenticate_user! 
  before_action :set_advance_money, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @advance_moneys = AdvanceMoney.order(date_advance: :desc)
    respond_with(@advance_moneys)
  end

  def show
    respond_with(@advance_money)
  end

  def new
    @advance_money = AdvanceMoney.new
    respond_with(@advance_money)
  end

  def edit
  end

  def create
    @advance_money = AdvanceMoney.new(advance_money_params)
    @advance_money.save
    respond_with(@advance_money)
  end

  def update
    @advance_money.update(advance_money_params)
    respond_with(@advance_money)
  end

  def destroy
    @advance_money.destroy
    respond_with(@advance_money)
  end

  private
    def set_advance_money
      @advance_money = AdvanceMoney.find(params[:id])
    end

    def advance_money_params
      params.require(:advance_money).permit(:date_advance, :number, :price)
    end
end
