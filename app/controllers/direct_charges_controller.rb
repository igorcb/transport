class DirectChargesController < ApplicationController
  before_action :set_direct_charge, only: [:show, :edit, :update, :destroy]

  respond_to :html

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
      params.require(:direct_charge).permit(:carrier_id, :driver_id, :place, :place_cart, :place_cart2, :date_charge, :palletized, 
        :quantity_pallets, :weight, :volume, :source_state, :source_city, :target_state, :target_city, 
        :observation, :user_id,
        nfe_xmls_attributes: [:asset, :equipamento, :id, :_destroy] 

        )
    end
end
