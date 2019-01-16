class VehicleRestrictionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vehicle, only: [:show], execept: [:unlock]
  load_and_authorize_resource


  def index
    @vehicle_restrictions = VehicleRestriction.locking
  end

  def show

  end

  def new
    @vehicle_restriction = VehicleRestriction.new
    @vehicle = Vehicle.find(params[:vehicle_id])
  end

  def create
    @vehicle = Vehicle.find(params[:vehicle_id])
    @vehicle_restriction = VehicleRestriction.new(vehicle_restriction_params)
    @vehicle_restriction.vehicle_id = @vehicle.id
    respond_to do |format|
      if @vehicle_restriction.save
        format.html { redirect_to dashboard_sup_path, flash: { success: "Vehicle Restriction was successfully locked." } }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def unlock
    @vehicle_restriction = VehicleRestriction.find(params[:id])
    VehicleRestriction.unlock(@vehicle_restriction)
    respond_to do |format|
      format.html { redirect_to vehicle_restrictions_path, flash: { success: "Vehicle Restriction was successfully unlocked." } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      #@vehicle_restriction = VehicleRestriction.find(params[:id])
      @vehicle_restriction = VehicleRestriction.first
      vehicle = @vehicle_restriction.vehicle
      #@vehicle = Vehicle.where(@vehicle_restriction.vehicle).first
    end

    def vehicle_restriction_params
      params.require(:vehicle_restriction).permit(:vehicle_id, :motive_id, :motive_observation)
    end
end
