class ControlPalletMailer < ActionMailer::Base
  add_template_helper ApplicationHelper
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper

  default from: "sistema@yohanwms.com.br""

  def notification_pallets(control_pallet)
    puts ">>>>>>>>>>>>>>>>>> Enviar Notificacao pallets"
    @control_pallet = control_pallet
    if Rails.env.development?
      email = ENV['RAILS_MAIL_DESTINATION']
    end
    if Rails.env.production?
      email = @control_pallet.client.emails.type_sector(Sector::TypeSector::PALLETS).pluck(:email)*","
    end
    text_subject = "NOTIFICAÇÃO DE ARMAZENAMENTO - NF: #{@control_pallet.nfe} "
    attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")
    puts ">>>>>>>>>>>>>>>>>>>> Envio de Email para #{email}"
    #send mail
    mail to: email, bcc: nil, subject: "#{text_subject}"  end
end
