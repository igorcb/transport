class AnttsVehiclesController < ApplicationController
	def new
		@antts_vehicles = AnttsVehicles.new
	end

	def show

	end

  def create

  	@antt = Antt.find(params[:antts_vehicles][:antt_id])
  	@vehicle = Vehicle.where(placa: params[:place]).first
  	@antts_vehicles = AnttsVehicles.new
  	if @vehicle.blank?
      @antts_vehicles.errors.add("AnttsVehicles", "Vehicle is not present.")
      return  		
  	end

  	@antts_vehicles = AnttsVehicles.new(antts_vehicles_params)
		@antts_vehicles.vehicle_id = @vehicle.id if @vehicle.present?
		if @antts_vehicles.save
  	  flash.now[:notice] = "AnttsVehicles add successfully." 
    else
      @antts_vehicles.errors.full_messages.each do |msg|
        flash[:error] = msg  
      end
	  end
  end

  private

	  def antts_vehicles_params
	  	params.require(:antts_vehicles).permit(:antt_id, :vehicle_id)
	  end
end
