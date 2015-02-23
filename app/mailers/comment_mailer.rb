class CommentMailer < ActionMailer::Base
  default from: "sistema@l7logistica.com.br"

  def notification(ordem_service)
  	time = Time.zone.now
    #@ordem_service_type_services = ordem_service_type_services
    @ordem_service = ordem_service
    @comments = @ordem_service.comments
    comment  = @comments.last
    email = "#{comment.email_destino}, igor.batista@l7logistica.com.br"
    #email = "igor.batista@gmail.com, igor.batista@l7logistica.com.br"
    text_subject = @comments.count < 1 ? "Nova Ocorrência Ordem Serviço No: #{@ordem_service.id}" : "Nova Interação Ordem Serviço No: #{@ordem_service.id}"
    #text_subject = "Nova Ocorrência Ordem Serviço No: #{ordem_service.id}"
    mail to: email, bcc: nil, subject: "#{text_subject} as #{time}"
  end

end
