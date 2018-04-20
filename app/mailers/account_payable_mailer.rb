class AccountPayableMailer < ActionMailer::Base
  default from: "sistema@l7logistica.com.br"

  def notification(account)
    time = Time.zone.now
    @account = account
    if Rails.env.development?
      email = ENV['RAILS_MAIL_DESTINATION']
    end
    if Rails.env.production?
      email_billing_client = @account.ordem_service.billing_client.emails.where(sector_id: Sector::TypeSector::FINANCEIRO).pluck(:email)
      email_target_client  = @account.ordem_service.client.emails.where(sector_id: Sector::TypeSector::FINANCEIRO).pluck(:email)
      email = email_billing_client + email_target_client
    end     
    #Assunto do e-mail colocar o numero do container - cliente de destino
    if @account.ordem_service.input_control.present?
      number_container = @account.ordem_service.input_control.container
      client_name      = @account.ordem_service.client.nome
    end
    text_subject = "COMPROVANTE PGTO - Container: #{number_container} - #{client_name}"

    attachments[@account.assets.first.asset_file_name] = File.read(Rails.root.join(@account.assets.first.asset.path)) if File.exist?(Rails.root.join(@account.assets.first.asset.path))

    mail to: email, bcc: nil, subject: "#{text_subject}"
  end
end