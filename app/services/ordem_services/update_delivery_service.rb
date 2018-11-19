module OrdemServices
  class UpdateDeliveryService
    def initialize(ordem_service, user)
      @ordem_service = ordem_service
      @user = user
    end

    def call
      # L7 LOGISTICA - Entrada de Mercadoria - Cria OrdemService - CriaEmbarque - Adiciona OrdemService no Embarque
      #               - OrdemService.update_delivery
      #byebug
      ActiveRecord::Base.transaction do

        OrdemService.where(id: @ordem_service.id).update_all(delivery_user_id: @user.id,
                                                           delivery_user_time: Date.current,
                                                                       status: OrdemService::TipoStatus::ENTREGA_EFETUADA)

        if @ordem_service.boarding.check_status_ordem_service_entregue?
          Boarding.where(id: @ordem_service.boarding).update(status: Boarding::TipoStatus::ENTREGUE)
        end
        OrdemServiceMailer.notification_delivery(@ordem_service).deliver_now #if ordem_service.input_control.present?
        return {success: true}
      end

      rescue Exception => exception
        return {success: false, error: exception.message}
    end
  end
end
