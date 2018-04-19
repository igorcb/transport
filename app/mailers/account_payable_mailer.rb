class AccountPayableMailer < ActionMailer::Base
  default from: "sistema@l7logistica.com.br"

  def notification(account)
    time = Time.zone.now
    @account = account
    if Rails.env.development?
      email = "igor.batista@gmail.com"  #ENV['RAILS_MAIL_DESTINATION']
    end
    if Rails.env.production?
      #email = "#{comment.email_destino}"
      email = "igor.batista@gmail.com"  #ENV['RAILS_MAIL_DESTINATION']
    end     
    #Assunto do e-mail colocar o numero do container - cliente de destino
    if @account.ordem_service.input_control.present?
      number_container = @account.ordem_service.input_control.container
      client_name      = @account.ordem_service.client.nome
    end
    text_subject = "Container: #{number_container} - #{client_name}"
    puts ">>>>>>>>>>>>>>>>>>>>>>>>>> SendMail: #{text_subject}"

    #attachments[@account.assets.first.asset_file_name] = File.read("#{Rails.root}#{@account.assets.first.asset.path}")
    #File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")
    

    attachments[@account.assets.first.asset_file_name] = File.read(Rails.root.join(@account.assets.first.asset.path)) if File.exist?(Rails.root.join(@account.assets.first.asset.path))
    # arr = @account.assets.pluck(:asset_file_name)
    # arr.each do |a|
    #   puts ">>>>>>>>>>>>>>>>>>>>>> File: #{a.url}"
    #   #File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")
    #   attachments[a] = File.read("#{Rails.root}#{a.url}")
    #   #attachments[a] = File.read(a)
    # end
    #attachments[] = File.read()
    # files.each do |file|
    #   attachments.push = "'#{file.asset_file_name}'"
    # end  

    mail to: email, bcc: nil, subject: "#{text_subject}"
  end
end

# [09:29, 16/4/2018] Uber Diego Sien: Diego Araújo Gonzaga 
# Siena preto el 1.0 
# Och 8323
# [09:30, 16/4/2018] Uber Diego Sien: Valor tu vê ai o quanto tu acha que pode meter ai
# [09:31, 16/4/2018] Uber Diego Sien: 15/04 as 5:20 da manha