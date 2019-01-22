class DriverRestrictionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_driver, only: [:show], execept: [:unlock]
  load_and_authorize_resource

  def index
    @driver_restrictions = DriverRestriction.locking
  end

  def show

  end

  def new
    @driver_restriction = DriverRestriction.new
    @driver = Driver.find(params[:driver_id])
  end

  def create
    @driver = Driver.find(params[:driver_id])
    @driver_restriction = DriverRestriction.new(driver_restriction_params)
    @driver_restriction.driver_id = @driver.id
    respond_to do |format|
      if @driver_restriction.save
        format.html { redirect_to dashboard_sup_path, flash: { success: "Driver Restriction was successfully locked." } }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def unlock
    @driver_restriction = DriverRestriction.find(params[:id])
    DriverRestriction.unlock(@driver_restriction)
    respond_to do |format|
      format.html { redirect_to driver_restrictions_path, flash: { success: "Driver Restriction was successfully unlocked." } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_driver
      #@vehicle_restriction = VehicleRestriction.find(params[:id])
      @driver_restriction = DriversRestriction.first
      vehicle = @driver_restriction.driver
      #@vehicle = Vehicle.where(@vehicle_restriction.vehicle).first
    end

    def driver_restriction_params
      params.require(:driver_restriction).permit(:client_id, :restriction, :observation)
    end

end
