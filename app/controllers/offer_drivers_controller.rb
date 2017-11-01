class OfferDriversController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_offer_driver, only: [:show, :edit, :update, :destroy, :confirmed]
  load_and_authorize_resource
  respond_to :html

  def index
    @offer_drivers = OfferDriver.all
    respond_with(@offer_drivers)
  end

  def show
    respond_with(@offer_driver)
  end

  def new
    @offer_driver = OfferDriver.new
    respond_with(@offer_driver)
  end

  def edit
  end

  def create
    # @offer_driver = OfferDriver.new(offer_driver_params)
    # @offer_driver.save
    # respond_with(@offer_driver)

    @offer_driver = OfferDriver.new(offer_driver_params)
    respond_to do |format|
      if @offer_driver.save
        format.html { redirect_to @offer_driver, flash: { success: "Offer Driver was successfully created." } }
        format.json { render action: 'show', status: :created, location: @offer_driver }
        format.js   { render action: 'show', status: :created, location: @offer_driver }
      else
        format.html { render action: 'new' }
        format.json { render json: @offer_driver.errors, status: :unprocessable_entity }
        format.js   { render json: @offer_driver.errors, status: :unprocessable_entity }
      end
    end    
  end

  def update
    @offer_driver.update(offer_driver_params)
    respond_with(@offer_driver)
  end

  def destroy
    @offer_driver.destroy
    respond_with(@offer_driver)
  end

  def confirmed
    OfferDriver.confirmed(@offer_driver)
    redirect_to offer_charge_path(@offer_driver.offer_charge)
  end

  def reject_form

  end

  def reject
    respond_to do |format|
      if @offer_driver.update(offer_driver_params) && OfferDriver.reject(@offer_driver)
        format.html { redirect_to offer_charge_path(@offer_driver.offer_charge), flash: { success: "Reject was successfully update." } }
        format.json { head :no_content }
      else
        format.html { render action: 'reject_form' }
        format.json { head :no_content }
      end
    end
  end

  def reject_observation
    
  end

  def noshow
    OfferDriver.noshow(@offer_driver)
    redirect_to offer_charge_path(@offer_driver.offer_charge)
  end

  def nonsuit
    OfferDriver.nonsuit(@offer_driver)
    redirect_to offer_charge_path(@offer_driver.offer_charge)
  end

  private
    def set_offer_driver
      @offer_driver = OfferDriver.find(params[:id])
    end

    def offer_driver_params
      params.require(:offer_driver).permit(:offer_charge_id, :user_id, :date_incoming, :time_incoming, :driver, :type_vehicle, 
        :place_horse, :place_cart_first, :place_cart_second, :observation, :status)
    end
end
