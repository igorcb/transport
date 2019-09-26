module Boardings
  class AddBoardingItemService

    def initialize(boarding, ordem_service, user)
      @user = user
      @boarding = boarding
      @ordem_service = ordem_service
    end

    def call
      #byebug
      return {success: false, message: "Boarding does not have the status OPEN."} if @boarding.status != Boarding::TipoStatus::ABERTO
      return {success: false, message: "Boarding has payment discharge."} if @boarding.account_payables.present?
      return {success: false, message: "O.S. does not exist."} if @ordem_service.nil?
      return {success: false, message: "O.S. does not have the status OPEN."} if @ordem_service.status != OrdemService::TipoStatus::ABERTO
      return {success: false, message: "O.S. be duplicated on boarding."} if @boarding.boarding_items.where(ordem_service_id: @ordem_service.id).present?

      begin
        ActiveRecord::Base.transaction do
          count = @ordem_service.count_boarding + 1
          @boarding.boarding_items.create(ordem_service_id: @ordem_service.id, delivery_number: 1)
          OrdemService.where(id: @ordem_service.id).update_all(status: OrdemService::TipoStatus::AGUARDANDO_EMBARQUE, count_boarding: count )
          Event.create(user_id: @user.id, controller_name: "BoardingItem", action_name: 'create' , what: "Adicionou a O.S. No: #{@ordem_service.id} do embarque No: #{@boarding.id}")
          return {success: true, message: "Boarding Items created successfully."}
        end
      rescue => e
        return {success: false, message: e.message}
      end
    end

    private
  end
end
