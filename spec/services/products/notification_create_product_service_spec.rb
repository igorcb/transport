require 'rails_helper'

RSpec.describe Products::NotificationCreateProductService, type: :service do
  describe "#call" do
    before(:each) do
      @user = FactoryBot.create(:user)
      @product = FactoryBot.create(:product)
    end

    it "when product not exist" do
      config_system = ConfigSystem.create!(config_key: 'EMAIL_USER_PRODUCT_NOTIFICATION', config_value: @user.email, config_description: "E-mail to be notified when creating a new product in the system.")
      result = Products::NotificationCreateProductService.new(nil).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Product is not exist.")
    end

    it "when product exist" do
      ConfigSystem.where(config_key: 'EMAIL_USER_PRODUCT_NOTIFICATION').destroy_all
      config_system = ConfigSystem.create!(config_key: 'EMAIL_USER_PRODUCT_NOTIFICATION', config_value: @user.email, config_description: "E-mail to be notified when creating a new product in the system.")
      result = Products::NotificationCreateProductService.new(@product).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Notification sent successfully.")
    end

    it "when e-mail is not configuration" do
      ConfigSystem.where(config_key: 'EMAIL_USER_PRODUCT_NOTIFICATION').destroy_all
      result = Products::NotificationCreateProductService.new(@product).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Sender e-mail not exist.")
    end

    it "when send notification" do
      ConfigSystem.where(config_key: 'EMAIL_USER_PRODUCT_NOTIFICATION').destroy_all
      config_system = ConfigSystem.create!(config_key: 'EMAIL_USER_PRODUCT_NOTIFICATION', config_value: @user.email, config_description: "E-mail to be notified when creating a new product in the system.")
      result = Products::NotificationCreateProductService.new(@product).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Notification sent successfully.")
    end
  end
end
