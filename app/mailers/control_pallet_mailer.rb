class ControlPalletMailer < ActionMailer::Base
  add_template_helper ApplicationHelper
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper
  
  default from: "pallets@l7logistica.com.br"

  def notification_pallets(control_pallet)
    puts ">>>>>>>>>>>>>>>>>> Enviar Notificacao pallets"
    @control_pallet = control_pallet
    if Rails.env.development?
      email = "igor.batista@gmail.com, paulogaldino@l7logistica.com.br"
    end
    if Rails.env.production?
      email = "pallets@l7logistica.com.br"
    end 
    text_subject = "NOTIFICAÇÃO DE ARMAZENAMENTO - NF: #{@control_pallet.nfe} "
    attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")

    #send mail
    mail to: email, bcc: nil, subject: "#{text_subject}"  end
end