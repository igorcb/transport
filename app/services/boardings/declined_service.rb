module Boardings
  class DeclinedService

    def initialize(boarding, user)
      @user = user
      @boarding = boarding
    end

    def call
      #byebug
      return {success: false, message: "Boarding is not exist."} if @boarding.blank? && @user.blank?
      return {success: false, message: "Boarding must be in status EMBARCADO."} if @boarding.status != Boarding::TipoStatus::EMBARCADO
      return {success: false, message: "Ordem Services to boarding must be in status EMBARCADO."} if @boarding.boarding_items.includes(:ordem_service).where.not(ordem_services: {status: OrdemService::TipoStatus::EMBARCADO}).present?
      #[]
      begin
        ActiveRecord::Base.transaction do
          Boarding.where(id: @boarding.id).update_all(status: Boarding::TipoStatus::REENTREGA)
          os_count_declined = 0
          os_ids = @boarding.boarding_items.pluck(:ordem_service_id)
          @boarding.boarding_items.each do |item|
            ordem_service = OrdemService.where(id: item.ordem_service_id).first
            os_count_declined = ordem_service.declined
            ordem_service.status = OrdemService::TipoStatus::ABERTO
            ordem_service.declined += os_count_declined
            ordem_service.save!
            os_count_declined = 0
          end
          @boarding.boarding_items.destroy_all
          Event.create(user_id: @user.id, controller_name: "Boarding", action_name: 'create', what: "Executou a reentrega do embarque No: #{@boarding.id}. O.S. do embarque: #{os_ids}")
          return {success: true, message: "Boarding decliend successfully."}
        end
      rescue => e
        return {success: false, message: e.message}
      end
    end

  private

  end
end
