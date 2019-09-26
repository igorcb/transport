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
        @ordem_service.nfe_keys.each {|nfe_key| nfe_key.edi_queues.create(status: 0)  }
        OrdemServiceMailer.notification_delivery(@ordem_service).deliver_now #if ordem_service.input_control.present?
        Event.create(user_id: @user.id, controller_name: "OrdemService", action_name: 'create' , what: "Realizou a Entrega a O.S. No: #{@ordem_service.id} do embarque No: #{@ordem_service.boarding.id}")
        return {success: true, message: "Ordem Service delivery successfully."}
      end

      rescue Exception => exception
        return {success: false, error: exception.message}
    end
  end
end
