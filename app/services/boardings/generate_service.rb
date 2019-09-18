module Boardings
  class GenerateService

    def initialize(ordem_service_ids)
      # @boarding = boarding
       @ordem_service_ids = ordem_service_ids
    end

    def call
      #byebug
      return {success: false, message: "Ordem Service not selected."} if @ordem_service_ids.blank?
      # return {success: false, message: "Boarding has payment discharge."} if @boarding.account_payables.present?
      # return {success: false, message: "O.S. does not exist."} if @ordem_service.nil?
      # return {success: false, message: "O.S. does not have the status OPEN."} if @ordem_service.status != OrdemService::TipoStatus::ABERTO
      # return {success: false, message: "O.S. be duplicated on boarding."} if @boarding.boarding_items.where(ordem_service_id: @ordem_service.id).present?

      begin
        ActiveRecord::Base.transaction do
          boarding = Boarding.create(driver_id: driver, carrier_id: carrier, status: Boarding::TipoStatus::ABERTO)
          hash_ids.each do |os|
          	boarding.boarding_items.create!(ordem_service_id: os, delivery_number: 1)
          end
          OrdemService.where(id: hash_ids).update_all(status: OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
          return {success: true, message: "Boarding Items created successfully."}
        end
      rescue => e
        return {success: false, message: e.message}
      end
    end

    private
  end
end
