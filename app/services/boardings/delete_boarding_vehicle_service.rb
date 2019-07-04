module Boardings
  class DeleteBoardingVehicleService
    # trocar os parametros por um hash
    def initialize(boarding_vehicle, user)
      @boarding_vehicle = boarding_vehicle
      @user = user
    end

    def call
      #byebug
      return {success: false, message: "Boarding does not have the status OPEN."} if @boarding_vehicle.boarding.status != Boarding::TipoStatus::ABERTO

      begin
        ActiveRecord::Base.transaction do
          Event.create(user_id: @user.id, controller_name: "BoardingVehicle", action_name: 'destroy' , what: "Deletou o Veiculo #{@boarding_vehicle.vehicle.placa} do embarque No: #{@boarding_vehicle.boarding.id}")
          BoardingVehicle.where(id: @boarding_vehicle.id).destroy_all
          return {success: true, message: "Boarding Vehicle delete successfully."}
        end
      rescue => e
        return {success: false, message: e.message}
      end
    end

    private
  end
end
