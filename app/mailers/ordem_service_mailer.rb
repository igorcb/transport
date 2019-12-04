class OrdemServiceMailer < ActionMailer::Base
  default from: "sistema@yohanwms.com.br"

  def notification_delivery(ordem_service)
    #byebug
    @ordem_service = ordem_service

    return if @ordem_service.billing_client.nil?
    return if @ordem_service.billing_client.emails.type_sector(Sector::TypeSector::CONFIRMACAO_ENTREGA).blank?

    email = @ordem_service.billing_client.emails.type_sector(Sector::TypeSector::CONFIRMACAO_ENTREGA).pluck(:email)*","

    text_subject = "NOTIFICAÇÃO DE ENTREGA - NF: #{@ordem_service.danfes}"
    attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")

    #send mail
    mail to: email, bcc: nil, subject: "#{text_subject}"
  end
end
