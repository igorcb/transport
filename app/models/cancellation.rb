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
      when "Boarding" then "Embarque"
      when "AccountPayable" then "Ct. a Pagar"
      when "Billing" then "Faturamento"
    end
  end

  def cancellation_model
    case self.cancellation_type.to_s
      when "Billing" then model = Billing.find(self.cancellation_id)
      when "Boarding" then model = Boarding.find(self.cancellation_id)
      when "OrdemService" then model = OrdemService.find(self.cancellation_id)
      when "AccountPayable" then model = AccountPayable.find(self.cancellation_id)
    end     
    model
  end

  def send_notification_solicitation_cancellation
  	CancellationMailer.notification_solicitation_cancellation(ordem_service).deliver!
  end

  def send_notification_cancellation
    CancellationMailer.notification_cancellation(ordem_service).deliver!
  end

  def self.confirm(user, id) #id = cancellation_id
  	# ActiveRecord::Base.transaction do
  	# 	cancel = Cancellation.find(id)
   #    #fazer um case para quando tiver outro tipo de cancelamento
  	# 	ordem_service = cancel.ordem_service
  	# 	OrdemService.update(ordem_service, status: OrdemService::TipoStatus::CANCELADA)
   #    Cancellation.update(id, authorization_user_id: user, status: TipoStatus::CONFIRMADO)
   #    #cancel.send_notification_cancellation
  	# end
    cancel = Cancellation.find(id)
    user = User.find(user)
    model = cancel.cancellation_model
    case model
      when Billing then cancel.cancel_billing(cancel, user)
      when Boarding then cancel.cancel_boarding(cancel, user)
      when OrdemService then cancel.cancel_ordem_service(cancel, user)
      when AccountPayable then cancel.cancel_account_payable(cancel, user)
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
      Billing.where(id: billing.id).update_all(status: Billing::TipoStatus::CANCELADA)
      Cancellation.where(id: cancel.id).update_all(authorization_user_id: user, status: TipoStatus::CONFIRMADO)
    end
  end

end
