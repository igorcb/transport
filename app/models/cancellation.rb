class Cancellation < ActiveRecord::Base
  validates :solicitation_user_id, presence: true
  validates :observacao, presence: true, length: { minimum: 15 }
  belongs_to :solicitation_user, class_name: "User", foreign_key: 'solicitation_user_id'
  belongs_to :authorization_user, class_name: "User", foreign_key: 'authorization_user_id'
  
  #belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "cancellation_id", polymorphic: true, dependent: :destroy
	
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

	def ordem_service
		ordem_service = OrdemService.find(self.cancellation_id)
	end

  def send_notification_solicitation_cancellation
  	CancellationMailer.notification_solicitation_cancellation(ordem_service).deliver!
  end

  def send_notification_cancellation
    CancellationMailer.notification_cancellation(ordem_service).deliver!
  end

  def self.confirm(user, id) #id = cancellation_id
  	ActiveRecord::Base.transaction do
  		cancel = Cancellation.find(id)
      #fazer um case para quando tiver outro tipo de cancelamento
  		ordem_service = cancel.ordem_service
  		OrdemService.update(ordem_service, status: OrdemService::TipoStatus::CANCELADA)
      Cancellation.update(id, authorization_user_id: user, status: TipoStatus::REJEITADO)
      #cancel.send_notification_cancellation
  	end
  end

  def self.rejected(user, id) #id = cancellation_id
    ActiveRecord::Base.transaction do
      cancel = Cancellation.find(id)
      #fazer um case para quando tiver outro tipo de cancelamento
      ordem_service = cancel.ordem_service
      OrdemService.update(ordem_service, status: OrdemService::TipoStatus::CANCELADA)
      Cancellation.update(id, authorization_user_id: user, status: TipoStatus::REJEITADO)
      #cancel.send_notification_cancellation
    end
  end
end
