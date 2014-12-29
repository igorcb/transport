class BillingsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_billing, only: [:show]
  load_and_authorize_resource

  respond_to :html, :xls

  def index
    @billings = Billing.order('id desc')
    respond_with(@billing)
    # respond_to do |format|
    #   format.html
    # end
  end

  def show
    respond_with(@billing)
    # respond_to do |format|
    #   format.html
    #   format.xls { send_data @billing.to_csv, type: "application/xls",filename: "Fatura_#{@billing.id}_L7-Logistica.xls" }
    # end 
  end

  # def new
  #   @billing = Billing.new
  #   respond_with(@billing)
  # end

  # def edit
  # end

  # def create
  #   @billing = Billing.new(billing_params)
  #   @billing.save
  #   respond_with(@billing)
  # end

  # def update
  #   @billing.update(billing_params)
  #   respond_with(@billing)
  # end

  # def destroy
  #   @billing.destroy
  #   respond_with(@billing)
  # end

  private
    def set_billing
      @billing = Billing.find(params[:id])
    end

    # def billing_params
    #   params.require(:billing).permit(:data, :valor, :status, :obs)
    # end
end

