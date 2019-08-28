class ProductMailer < ApplicationMailer

  default from: "sistema@l7logistica.com.br"

  def notification_product(product)
    @product = product
    email = ConfigSystem.where(config_key: 'EMAIL_USER_PRODUCT_NOTIFICATION').first.config_value
    text_subject = "NEW PRODUCT: #{@product.id} - Descricao: #{@product.descricao.upcase} "
    mail to: email, bcc: nil, subject: "#{text_subject}"
  end

end
