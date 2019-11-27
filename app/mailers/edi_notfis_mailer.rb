class EdiNotfisMailer < ApplicationMailer
  default from: "sistema@yohanmws.com.br"

  def notification(file_name, file, cnpj)
    @date = Date.current.strftime('%d/%m/%Y')
    email = 'igor.batista@gmail.com, paulogaldino@l7logistica.com.br, '
    email += Client.where(cpf_cnpj: cnpj).first.emails.type_sector(Sector::TypeSector::EDI_NOTFIS_ENTREGA).pluck(:email)*","

    text_subject = "Arquivos EDI - OCOREN referente ao dia #{@date}"

    #attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")
    attachments.inline["#{file_name}"] = file

    mail to: email, bcc: nil, subject: "#{text_subject}"
  end
end
