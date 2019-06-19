module Boardings
  class AddVehiclesService

    def initialize(boarding, vehicle)
      @boarding = boarding
      @vehicle = vehicle
    end

    def call
      #byebug
      return {success: false, message: "Boarding, vehicle does not exist."} if !@vehicle.present?
      return {success: false, message: "Boarding, must have at least one vehicle."} if BoardingVehicle.where(boarding_id: @boarding.id, vehicle_id: @vehicle.id).present?
      case @vehicle.tipo
        when Vehicle::Tipo::TRACAO then
          return {success: false, message: "Boarding, vehicles are of the same type."} if BoardingVehicle.joins(:vehicle).where(boarding_id: @boarding.id, vehicles: {tipo: Vehicle::Tipo::TRACAO}).present?
        when Vehicle::Tipo::REBOQUE then
          return {success: false, message: "Boarding, vehicles are of the same type."} if BoardingVehicle.joins(:vehicle).where(boarding_id: @boarding.id, vehicles: {tipo: Vehicle::Tipo::REBOQUE}).present?
        # when Vehicle::Tipo::TRACAO_BAU then
        #   return {success: false, message: "Boarding, vehicle can only have one TRACAO_BAU."} if BoardingVehicle.joins(:vehicle).where(boarding_id: @boarding.id, vehicles: {tipo: Vehicle::Tipo::TRACAO_BAU}).present?
      end

      @vehicles = BoardingVehicle.where(boarding_id: @boarding.id)
      if @vehicles.count == 1
        vehicle = @vehicles.first
        if vehicle.vehicle.tipo == Vehicle::Tipo::TRACAO_BAU
          return {success: false, message: "Boarding, you can not have another type of vehicle."} if @vehicles.present?
        end
      end
      if @vehicles.count == 2
        vehicle = BoardingVehicle.joins(:vehicle).where(boarding_id: @boarding.id, vehicles: {tipo: [Vehicle::Tipo::TRACAO, Vehicle::Tipo::REBOQUE]})
        if vehicle.present?
          return {success: false, message: "Boarding, you already have the types of vehicles."}
        end
      end

      begin
        ActiveRecord::Base.transaction do
          # BoardingItem.where(ordem_service_id: @ordem_service.id).destroy_all
          @boarding.boarding_vehicles.create!(vehicle_id: @vehicle.id)
          return {success: true, message: "Boarding, vehicle created successfully."}
        end
      rescue => e
        return {success: false, message: e.message}
      end
    end

    private
  end
end
