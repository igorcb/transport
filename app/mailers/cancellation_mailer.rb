class CancellationMailer < ActionMailer::Base
  default from: "sistema@yohanwms.com.br"

  def notification_solicitation_cancellation(ordem_service)
  	@ordem_service = ordem_service
  	email = "administrativo@l7logistica.com.br, igor.batista@l7logistica.com.br"
  	mail to: email, bcc: nil, subject: "Solicitacao de cancelamento OS.: #{@ordem_service.id}"
  end

  def notification_cancellation(ordem_service)
  	@ordem_service = ordem_service
  	email = "paulogaldino@l7logistica.com.br, igor.batista@l7logistica.com.br"
  	mail to: email, bcc: nil, subject: "Confirmação de cancelamento OS.: #{@ordem_service.id}"
  end

  def notification_rejected_cancellation(ordem_service)
    @ordem_service = ordem_service
    email = "paulogaldino@l7logistica.com.br, igor.batista@l7logistica.com.br"
    mail to: email, bcc: nil, subject: "Confirmação de cancelamento OS.: #{@ordem_service.id}"
  end

end
