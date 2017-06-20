class CommentMailer < ActionMailer::Base
  add_template_helper ApplicationHelper
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper

  default from: "sistema@l7logistica.com.br"

  def notification(ordem_service)
  	time = Time.zone.now
    @ordem_service = ordem_service
    @comments = @ordem_service.comments
    comment  = @comments.last
    email = "#{comment.email_destino}, igor.batista@l7logistica.com.br"
    #text_subject = @comments.count < 1 ? "Nova Ocorrência OS. No: #{@ordem_service.id}" : "Nova Interação OS No: #{@ordem_service.id}"
    cte = @ordem_service.cte_keys.present? ? "CT-e: #{@ordem_service.cte_keys.first.cte}" : "CTE: ?"
    placa = @ordem_service.ordem_service_logistics.present? ? @ordem_service.ordem_service_logistic.placa : @ordem_service.placa  
    text_subject = "#{cte} / Danfe: #{@ordem_service.danfes} / Placa: #{placa}"
    mail to: email, bcc: nil, subject: "#{text_subject}"
  end

  def notification_boarding(boarding)
    @boarding = boarding
    @comments = @boarding.comments
    comment  = @comments.last
    email = "#{comment.email_destino}, igor.batista@l7logistica.com.br"
    text_subject = "OCORRENCIA: NF #{@boarding.get_number_nfe}"
    #anexar imagens
    photo = Asset.last
    #attachments["#{photo.asset_file_name}"] = File.read("#{photo.asset.path}")
    #attachments.inline['photo.png'] = File.read('path/to/photo.png')

    ## Essa logo deve ser pego do usuário que está enviando a ocorrencia ou 
    ## pegar uma imagem padrão para assinatura
    attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")

    ## anexar as imagens das avarias
    attachments.inline["#{photo.asset_file_name}"] = File.read("#{photo.asset.path}")
    mail to: email, bcc: nil, subject: "#{text_subject}"

  end

end
