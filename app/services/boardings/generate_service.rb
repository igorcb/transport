module Boardings
  class GenerateService

    def initialize(ordem_service_ids)
      # @boarding = boarding
       @ordem_service_ids = ordem_service_ids
    end

    def call
      #byebug
      return {success: false, message: "Ordem Service not selected."} if @ordem_service_ids.blank?
      return {success: false, message: "Default driver key, not set."} if !driver_not_information?
      return {success: false, message: "Default carrier key, not set."} if !carrier_not_information?
      return {success: false, message: "Selected work ordem_service must be in status OPEN."} if !status_open?(@ordem_service_ids)
      
      driver = Driver.where(id: ConfigSystem.where(config_key: 'DRIVER_DEFAULT').first.config_value).first
      carrier = Carrier.where(id: ConfigSystem.where(config_key: 'CARRIER_DEFAULT').first.config_value).first

      begin
        ActiveRecord::Base.transaction do
          boarding = Boarding.create!(driver: driver, carrier: carrier, status: Boarding::TipoStatus::ABERTO)
          @ordem_service_ids.each do |ordem_service|
          	boarding.boarding_items.create!(ordem_service_id: ordem_service, delivery_number: 1)
          end
          OrdemService.where(id: @ordem_service_ids).update_all(status: OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
          return {success: true, message: "Boarding created successfully."}
        end
      rescue => e
        return {success: false, message: e.message}
      end
    end

    private

      def driver_not_information?
        result = true
        conf = ConfigSystem.where(config_key: 'DRIVER_DEFAULT').first
        if conf.present?
          conf.config_value.to_i
          return false if !Driver.where(id: conf.config_value.to_i).present?
        else
          return false
        end
        result = true
      end

      def carrier_not_information?
        result = true
        conf = ConfigSystem.where(config_key: 'CARRIER_DEFAULT').first
        if conf.present?
          conf.config_value.to_i
          return false if !Carrier.where(id: conf.config_value.to_i).present?
        else
          return false
        end
        result = true
      end

      def status_open?(ordem_service_ids)
        positivo = true
        ordem_service_ids.each do |id|
          ordem_service = OrdemService.where(id: id).first
          return false if ordem_service.status != OrdemService::TipoStatus::ABERTO
        end
        positivo
      end
  end
end
