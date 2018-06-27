class NfeKeyMailer < ActionMailer::Base
  default from: "sistema@l7logistica.com.br"

  def request_receipt(nfe_key)
    @nfe_key = nfe_key
    if Rails.env.development?
      email = ENV['RAILS_MAIL_DESTINATION']
    end
    if Rails.env.production?
      #email = @ordem_service.billing_client.emails.type_sector(Sector::TypeSector::CONFIRMACAO_ENTREGA).pluck(:email)*","
    end 
    text_subject = "Declaração de Recebimento de Mercadoria NFe: #{nfe_key.nfe} "
    attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")

    #send mail
    mail to: email, bcc: nil, subject: "#{text_subject}"
  end
end
