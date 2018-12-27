class EdiNotfisMailer < ApplicationMailer
  default from: "sistema@l7logistica.com.br"

  def notification(file_name, file, cnpj)

    #email = Client.where(cpf_cnpj: cnpj).first.emails.type_sector(Sector::TypeSector::EDI_NOTFIS_ENTREGA).pluck(:email)*","
    email = 'igor.batista@gmail.com, paulogaldino@l7logistica.com.br'
    text_subject = "Arquivos Edi NotFis referente ao dia #{Date.current.strftime('%d/%m/%Y')}"

    #attachments.inline['assinatura_paulo.png'] = File.read("#{Rails.root}/app/assets/images/assinatura_paulo.png")
    attachments.inline["#{file_name}"] = file

    mail to: email, bcc: nil, subject: "#{text_subject}"
  end
end
