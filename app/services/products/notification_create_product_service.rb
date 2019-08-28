module Products
  class NotificationCreateProductService

    def initialize(product)
      @product = product
    end

    def call
      return {success: false, message: "Product is not exist."} if @product.blank?
      return {success: false, message: "Sender e-mail not exist."} if @qtde_pallet.blank?
      #Criar notificação para aparecer no sino
      #return {success: false, message: "Qtde Pallets must be greater than 0 (zero)."} if @qtde_pallet.blank?

      begin
        ActiveRecord::Base.transaction do

          return {success: true, message: "Notification sent successfully."}
        end
      rescue => e
        puts e.message
        return {success: false, message: e.message}
      end
    end
  end
end
