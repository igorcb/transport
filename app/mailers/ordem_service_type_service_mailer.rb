class OrdemServiceTypeServiceMailer < ApplicationMailer
  default from: "administrativo@l7logistica.com.br"

  def report_mailer(ordem_service_type_services)
  	time = Time.now
    @ordem_service_type_services = ordem_service_type_services
    email = 'igor.batista@gmail.com'
    mail to: email, bcc: nil, subject: "Relatorio de Pagamentos Efetuados #{time}"
  end
end
