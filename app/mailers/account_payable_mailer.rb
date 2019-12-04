class AccountPayableMailer < ActionMailer::Base
  default from: "sistema@yohanwms.com.br"

  def notification(account)
    time = Time.zone.now
    @account = account

    email = ENV['RAILS_MAIL_DESTINATION'] if Rails.env.development?
    if Rails.env.production?
      email_billing_client = @account.ordem_service.billing_client.emails.where(sector_id: Sector::TypeSector::FINANCEIRO).pluck(:email)
      email_target_client  = @account.ordem_service.client.emails.where(sector_id: Sector::TypeSector::FINANCEIRO).pluck(:email)
      email_carrier = @account.ordem_service.input_control.carrier.emails.where(sector_id: Sector::TypeSector::FINANCEIRO).pluck(:email) if @account.ordem_service.input_control.carrier.present?
      email = email_billing_client + email_target_client + email_carrier
    end

    if @account.ordem_service.input_control.present?
      number_container = @account.ordem_service.input_control.container
      client_name      = @account.ordem_service.client.nome
    end
    text_subject = "COMPROVANTE PGTO - Container: #{number_container} - #{client_name}"

    attachments[@account.assets.first.asset_file_name] = File.read(Rails.root.join(@account.assets.first.asset.path)) if File.exist?(Rails.root.join(@account.assets.first.asset.path))

    mail to: email, bcc: nil, subject: "#{text_subject}"
    count = @account.count_email + 1
    puts ">>>>>>>>>>>>>>>>> Count: #{count}"
    AccountPayable.where(id: @account.id).update_all(count_email: count)
  end
end
