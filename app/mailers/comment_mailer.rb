class CommentMailer < ActionMailer::Base
  default from: "sistema@l7logistica.com.br"

  def notification(ordem_service)
  	time = Time.zone.now
    @ordem_service = ordem_service
    @comments = @ordem_service.comments
    comment  = @comments.last
    email = "#{comment.email_destino}, igor.batista@l7logistica.com.br"
    #text_subject = @comments.count < 1 ? "Nova Ocorrência OS. No: #{@ordem_service.id}" : "Nova Interação OS No: #{@ordem_service.id}"
    cte = @ordem_service.cte_keys.present? ? "CT-e: #{@ordem_service.cte_keys.first.cte}" : "CTE: ?"
    placa = @ordem_service.ordem_service_logistics.present? ? @ordem_service.ordem_service_logistic.placa : @ordem_service.placa  
    text_subject = "#{cte} / Danfe: #{@ordem_service.danfes} / Placa: #{placa}"
    mail to: email, bcc: nil, subject: "#{text_subject}"
  end

end
