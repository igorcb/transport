class Cancellation < ActiveRecord::Base
  validates :solicitation_user_id, presence: true
  validates :observacao, presence: true, length: { minimum: 15 }
  belongs_to :solicitation_user, class_name: "User", foreign_key: 'solicitation_user_id'
  belongs_to :authorization_user, class_name: "User", foreign_key: 'authorization_user_id'
  
  # belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "cancellation_id", polymorphic: true, dependent: :destroy
  # belongs_to :boarding, class_name: "Boarding", foreign_key: "cancellation_id", polymorphic: true, dependent: :destroy
  # belongs_to :cancel, class_name: "Cancellation", foreign_key: "cancellation_id", polymorphic: true

  module TipoStatus
  	PEDENDENTE = 0
  	CONFIRMADO = 1
    REJEITADO = 1
  end

  def status_name
	  case self.status
		  when 0 then "Pedendente"
	  	when 1 then "Confirmado"
      when 2 then "Rejeitado"
		end
  end

  def pode_cancelar?
  	self.status == TipoStatus::PEDENDENTE
  end

  def cancellation_type_name
    case self.cancellation_type.to_s
      when "OrdemService" then "O.S."
      when "InputControl" then "Rem. Entrada"
      when "Boarding" then "Embarque"
      when "AccountPayable" then "Ct. a Pagar"
      when "Billing" then "Faturamento"
      when "NfsKey" then "NFS"
      when "OfferCharge" then "Oferta de Carga"
    end
  end

  def cancellation_model
    case self.cancellation_type.to_s
      when "Billing" then model = Billing.find(self.cancellation_id)
      when "Boarding" then model = Boarding.find(self.cancellation_id)
      when "OrdemService" then model = OrdemService.find(self.cancellation_id)
      when "AccountPayable" then model = AccountPayable.find(self.cancellation_id)
      when "NfsKey" then model = NfsKey.find(self.cancellation_id)
      when "InputControl" then model = InputControl.find(self.cancellation_id)
      when "OfferCharge" then model = OfferCharge.find(self.cancellation_id)
    end     
    model
  end

  def cancellation_type_model
    case self.cancellation_type.to_s
      when "Billing" then model = Billing.find(self.cancellation_id)
      when "Boarding" then model = Boarding.find(self.cancellation_id)
      when "OrdemService" then model = OrdemService.find(self.cancellation_id)
      when "AccountPayable" then model = AccountPayable.find(self.cancellation_id)
      when "NfsKey" then model = NfsKey.ordem_service(self.cancellation_id)
      when "InputControl" then model = InputControl.find(self.cancellation_id)
      when "OfferCharge" then model = OfferCharge.find(self.cancellation_id)
    end     
    model
  end

  def send_notification_solicitation_cancellation
  	CancellationMailer.notification_solicitation_cancellation(ordem_service).deliver!
  end

  def send_notification_cancellation
    CancellationMailer.notification_cancellation(ordem_service).deliver!
  end

  # def confirm?(user)
  #   Cancellation.confirm?(user, self.id)
  # end

  def self.confirm?(user, id) #id = cancellation_id
    cancel = Cancellation.find(id)
    user = User.find(user)
    model = cancel.cancellation_model
    case model
      when Billing then cancel.cancel_billing(cancel, user)
      when Boarding then cancel.cancel_boarding(cancel, user)
      when OrdemService then cancel.cancel_ordem_service(cancel, user)
      when AccountPayable then cancel.cancel_account_payable(cancel, user)
      when NfsKey then cancel.cancel_nfs_key(cancel, user)
      when InputControl then cancel.cancel_input_control(cancel, user)
      when OfferCharge then cancel.cancel_offercharge_control(cancel, user)
    end
    #cancel.send_notification_cancellation
  end

  def self.rejected(user, id) #id = cancellation_id
    ActiveRecord::Base.transaction do
      #fazer um case para quando tiver outro tipo de cancelamento
      model = cancel.cancellation_model
      OrdemService.update(ordem_service, status: OrdemService::TipoStatus::CANCELADA)
      Cancellation.update(id, authorization_user_id: user, status: TipoStatus::REJEITADO)
      #cancel.send_notification_cancellation
    end
  end
  
  def cancel_ordem_service(cancel, user)
    # colocar status da ordem de servico como cancelada
    # colocar status do cancelamento como CONFIRMADO
    ActiveRecord::Base.transaction do
      ordem_service = cancel.cancellation_model
      OrdemService.where(id: ordem_service.id).update_all(status: OrdemService::TipoStatus::CANCELADA)
      Cancellation.where(id: cancel.id).update_all(authorization_user_id: user, status: TipoStatus::CONFIRMADO)
    end
  end

  def cancel_boarding(cancel, user)
    # voltar status da ordem de servico como AGUARDANDO_EMBARQUE
    # colocar status do embarque como CANCELADO
    # colocar status do cancelamento como CONFIRMADO
    ActiveRecord::Base.transaction do
      cancel = Cancellation.find(id)
      boarding = cancel.cancellation_model
      hash_ids = boarding.ordem_services_ids
      OrdemService.where(id: hash_ids).update_all(status: OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
      Boarding.where(id: boarding.id).update_all(status: Boarding::TipoStatus::CANCELADO)
      Cancellation.where(id: cancel.id).update_all(authorization_user_id: user, status: TipoStatus::CONFIRMADO)
    end
  end

  def cancel_account_payable(cancel, user)
    # colocar status da ordem de servico como cancelada
    # colocar status do cancelamento como CONFIRMADO
    ActiveRecord::Base.transaction do
      account_payable = cancel.cancellation_model
      AccountPayable.where(id: account_payable.id).update_all(status: AccountPayable::TipoStatus::CANCELADO)
      Cancellation.where(id: cancel.id).update_all(authorization_user_id: user, status: TipoStatus::CONFIRMADO)
    end
  end

  def cancel_billing(cancel, user)
    # colocar status da ordem de servico como cancelada
    # colocar status do cancelamento como CONFIRMADO
    ActiveRecord::Base.transaction do
      billing = cancel.cancellation_model
      ids = billing.ordem_service_ids
      Billing.where(id: billing.id).update_all(status: Billing::TipoStatus::CANCELADA)
      OrdemService.where(id: ids).update_all(status: OrdemService::TipoStatus::FECHADO)
      Cancellation.where(id: cancel.id).update_all(authorization_user_id: user, status: TipoStatus::CONFIRMADO)
    end
  end

  def cancel_nfs_key(cancel, user)
    # colocar status da ordem de servico como cancelada
    # colocar status do cancelamento como CONFIRMADO
    ActiveRecord::Base.transaction do
      nfs = cancel.cancellation_model
      #NfsKey.where(id: nfs.id).update_all(status: "OrdemService::TipoStatus::CANCELADA")
      Cancellation.where(id: cancel.id).update_all(authorization_user_id: user, status: TipoStatus::CONFIRMADO)
    end
  end

  def cancel_input_control(cancel, user)
    # colocar status da remessa de entrada como aberta
    # se tiver contas a receber, excluir 
      # se tiver com o pgto efetuado, não deixa excluir o contas a receber
    # colocar status do cancelamento como CONFIRMADO
    begin
      ActiveRecord::Base.transaction do
        input_control = cancel.cancellation_model
        account_receivable = AccountReceivable.find(input_control.account_receivable)
        account_receivable.destroy!
        InputControl.where(id: input_control.id).update_all(status: InputControl::TypeStatus::OPEN)
        Cancellation.where(id: cancel.id).update_all(authorization_user_id: user, status: TipoStatus::CONFIRMADO)
        return true
      end
      rescue Exception => e
        puts e.message
        self.errors.add(:cancellation, e.message)
        return false        
    end
  end

  def cancel_offercharge_control(cancel, user)
    begin
      ActiveRecord::Base.transaction do
        offer_charge = cancel.cancellation_model
        OfferCharge.where(id: offer_charge.id).update_all(status: OfferCharge::TypeStatus::CANCEL)
        Cancellation.where(id: cancel.id).update_all(authorization_user_id: user, status: TipoStatus::CONFIRMADO)
        return true
      end
      rescue Exception => e
        puts e.message
        self.errors.add(:cancellation, e.message)
        return false        
    end
  end
end
