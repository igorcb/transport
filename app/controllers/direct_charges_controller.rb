class DirectChargesController < ApplicationController
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper

  before_filter :authenticate_user!
  before_action :set_direct_charge, only: [:show, :edit, :update, :destroy, :select_nfe, :finish_typing]
  #load_and_authorize_resource  

  respond_to :html

  def create_ordem_service
    @direct_charge = DirectCharge.find(params[:id])

    puts ">>>>>>>>>>>>>>>>>>>>> DirectCharge: #{@direct_charge.id}"

    if params[:nfe].blank?
      flash[:danger] = "Select at least one nfe to generate the ordem service."
      respond_with(@direct_charge)
      return
    end
    if !@direct_charge.status_finish_typing?
      flash[:danger] = "First declare that you finish_typing"
      respond_with(@direct_charge)
      return
    elsif @direct_charge.date_charge.blank?
      flash[:danger] = "Date Charge can not be blank."
      respond_with(@direct_charge)
      return
    end
    # criar um modulo para get_hash_ids e check_client_billing
    ids = OrdemService.get_hash_ids(params[:nfe][:ids])
    puts ">>>>>>>>>>>>>>>>>>>>>>> check_client_billing: #{InputControl.check_client_billing?(ids)} <<<<<<<<<<<<<<<<<<<<<<<<"
    if !InputControl.check_client_billing?(ids)
      flash[:danger] = "Customer invoices are not the same."
      respond_with(@direct_charge)
      return
    end
    DirectCharge.create_ordem_service_input_controls({id: params[:id], nfe: ids})
    puts ">>>>>>>>>>>>>ID Direct Charge: #{@direct_charge.id} "
    respond_with(@direct_charge)
  end

  def finish_typing
    if @direct_charge.finish_typing
      flash[:success] = "Direct Charge was successfully received"
    else
      flash[:success] = "Error finish typing Direct Charge."
    end
    redirect_to direct_charge_path(@direct_charge)
  end


  def index
    @direct_charges = DirectCharge.all
    respond_with(@direct_charges)
  end

  def show
    respond_with(@direct_charge)
  end

  def new
    @direct_charge = DirectCharge.new
    respond_with(@direct_charge)
  end

  def edit
  end

  def create
    driver  = Driver.find_by_cpf(params[:driver_cpf])
    carrier = Carrier.find_by_cnpj(params[:carrier_cnpj])

    @direct_charge = DirectCharge.new(direct_charge_params)

    @direct_charge.driver_id = driver.id
    @direct_charge.carrier_id = carrier.id
    @direct_charge.user_id = current_user.id

    @direct_charge.save
    respond_with(@direct_charge)
  end

  def update
    @direct_charge.update(direct_charge_params)
    respond_with(@direct_charge)
  end

  def destroy
    @direct_charge.destroy
    respond_with(@direct_charge)
  end

  private
    def set_direct_charge
      @direct_charge = DirectCharge.find(params[:id])
    end

    def direct_charge_params
      params.require(:direct_charge).permit(:carrier_id, :driver_id, :place, :place_cart, :place_cart_2, :date_charge, :palletized, 
        :quantity_pallets, :weight, :volume, :source_state, :source_city, :target_state, :target_city, 
        :observation, :user_id,
        nfe_xmls_attributes: [:asset, :equipamento, :id, :_destroy] 

        )
    end
end
