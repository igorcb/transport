module Boardings
  class AddBoardingItemService

    def initialize(boarding, ordem_service)
      @boarding = boarding
      @ordem_service = ordem_service
    end

    def call
      #byebug
      return {success: false, message: "Boarding does not have the status OPEN."} if @boarding.status != Boarding::TipoStatus::ABERTO
      return {success: false, message: "Boarding has payment discharge."} if @boarding.account_payables.present?

      return {success: false, message: "O.S. does not have the status OPEN."} if @ordem_service.status != OrdemService::TipoStatus::ABERTO
      return {success: false, message: "O.S. be duplicated on boarding."} if @boarding.boarding_items.where(ordem_service_id: @ordem_service.id).present?

      begin
        ActiveRecord::Base.transaction do
          @boarding.boarding_items.create(ordem_service_id: @ordem_service.id, delivery_number: 1)
          OrdemService.where(id: @ordem_service.id).update_all(status: OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
          return {success: true, message: "Boarding Items created successfully."}
        end
      rescue => e
        #puts e.message
        return {success: false, message: e.message}
      end
    end

    private
  end
end
