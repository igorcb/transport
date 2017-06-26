class OrdemServiceMailer < ActionMailer::Base
  default from: "sistema@l7logistica.com.br"

  def notification_delivery(ordem_service)
    @ordem_service = ordem_service
    if Rails.env.development?
    	email = "igor.batista@gmail.com"
    end
    if Rails.env.production?
    	email = "larissa.fonceca@ype.ind.br, josiana.diana@ype.ind.br, paulogaldino@l7logistica.com.br"
    end	
    text_subject = "NOTIFICAÇÃO DE ENTREGA - NF: #{@ordem_service.danfes} "
    attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")

    #send mail
    mail to: email, bcc: nil, subject: "#{text_subject}"
  end
end
