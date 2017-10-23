class OfferChargesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_offer_charge, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html

  def index
    @offer_charges = OfferCharge.all
    respond_with(@offer_charges)
  end

  def show
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

  private
    def set_offer_charge
      @offer_charge = OfferCharge.find(params[:id])
    end

    def offer_charge_params
      params.require(:offer_charge).permit(:shipper, :date_shipment, :time_shipment, :shipping, :local_loading, 
        :type_vehicle, :vehicle_detail, :vehicle_situation, :freight_min, :freight_max,
        offer_items_attributes: [:offer_charge_id, :city, :state, :client, :date_schedule,:time_schedule, :qtde_pallets, :volume, :weight, :id, :_destroy]
        )
    end
end
