module Products
  class NotificationCreateProductService

    def initialize(product)
      @product = product
      @config_system = ConfigSystem.where(config_key: 'EMAIL_USER_PRODUCT_NOTIFICATION').first
      @user = User.where(email: @config_system.config_value).first if @config_system.present?
    end

    def call
      return {success: false, message: "Product is not exist."} if @product.blank?
      return {success: false, message: "Sender e-mail not exist."} if !@config_system.present?
      return {success: false, message: "User e-mail not exist."} if !@user.present?

      begin
        ActiveRecord::Base.transaction do
          Notification.create(recipient: @user, actor: @user, action: 'productd', notifiable: @product)
          ProductMailer.notification_product(@product).deliver_now
          return {success: true, message: "Notification sent successfully."}
        end
      rescue => e
        puts e.message
        return {success: false, message: e.message}
      end
    end
  end
end
