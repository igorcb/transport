class OfferChargesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_offer_charge, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html

  def index
    @q = OfferCharge.where(status: -1).search(params[:query])
    @offer_charges = OfferCharge.only_open
    respond_with(@offer_charges)
  end

  def show
    @offer_driver = OfferDriver.new
    @cancellation = @offer_charge.cancellations.build
    respond_with(@offer_charge)
  end

  def new
    @offer_charge = OfferCharge.new
    respond_with(@offer_charge)
  end

  def edit
  end

  def create
    @offer_charge = OfferCharge.new(offer_charge_params)
    @offer_charge.user_id = current_user.id
    @offer_charge.save
    respond_with(@offer_charge)
  end

  def update
    @offer_charge.update(offer_charge_params)
    respond_with(@offer_charge)
  end

  def destroy
    @offer_charge.destroy
    respond_with(@offer_charge)
  end

  def search
    @q = OfferCharge.search(params[:query])
    @offer_charges = @q.result
    respond_with(@offer_charges) do |format|
     format.js
    end
  end

  private
    def set_offer_charge
      @offer_charge = OfferCharge.find(params[:id])
    end

    def offer_charge_params
      params.require(:offer_charge).permit(:shipper, :date_shipment, :time_shipment, :shipping, :local_loading, 
        :type_vehicle, :vehicle_detail, :vehicle_situation, :freight_min, :freight_max, :local_landing, :palletized,
        offer_items_attributes: [:offer_charge_id, :city, :state, :client, :date_schedule,:time_schedule, :qtde_pallets, :volume, :weight, :id, :_destroy],
        offer_drivers_attributes: [:offer_charge_id, :date_incoming, :time_incoming, :driver, :type_vehicle, :place_horse, :place_cart_first, :place_cart_second, :user_id, :id, :_destroy]
        )
    end
end
