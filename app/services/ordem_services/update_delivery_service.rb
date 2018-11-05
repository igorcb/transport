module OrdemServices
  class UpdateDeliveryService
    def initialize(ordem_service, user)
      @ordem_service = ordem_service
      @user = user
    end

    def call
      # L7 LOGISTICA - Entrada de Mercadoria - Cria OrdemService - CriaEmbarque - Adiciona OrdemService no Embarque
      #               - OrdemService.update_delivery
      ActiveRecord::Base.transaction do
        @boarding = @ordem_service.boarding_item.boarding
        OrdemService.where(id: @ordem_service.id).update_all(delivery_user_id: @user.id,
                                                           delivery_user_time: Date.current,
                                                                       status: OrdemService::TipoStatus::ENTREGA_EFETUADA)
        
        if @boarding.check_status_ordem_service_entregue?
          Boarding.where(
            id: @ordem_service.boarding_item.boarding
          ).update(status: Boarding::TipoStatus::ENTREGUE)
        end
        return {success: true}
      end

      rescue Exception => exception
        return {success: false, error: exception.message}
    end
  end
end
