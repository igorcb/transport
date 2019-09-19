require 'rails_helper'

RSpec.describe Boardings::GenerateService, type: :service do

  context "generate" do
    before(:each) do
      #byebug
      #@user = FactoryBot.create(:user)
      @ordem_service_first = FactoryBot.create(:ordem_service)
      @ordem_service_second = FactoryBot.create(:ordem_service)
      @ordem_service_third = FactoryBot.create(:ordem_service)
      @ordem_service_ids = [@ordem_service_first.id, @ordem_service_second.id, @ordem_service_third.id]
    end

    it "when ordem service is not exist" do
      result = Boardings::GenerateService.new(nil).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Ordem Service not selected.")
    end

    it "when the default driver key and driver does not exist" do
      ConfigSystem.where(config_key: 'DRIVER_DEFAULT').destroy_all
      result = Boardings::GenerateService.new(@ordem_service_ids).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Default driver key, not set.")
    end

    it "when the default carrier key and carrier does not exist" do
      ConfigSystem.where(config_key: 'CARRIER_DEFAULT').destroy_all
      result = Boardings::GenerateService.new(@ordem_service_ids).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Default driver key, not set.")
    end

    it "when the ordem_service is not as OPEN" do
      ConfigSystem.create_with(config_key: "DRIVER_DEFAULT", config_value: "1", config_description: "Motorista padrão do sistema").find_or_create_by(config_key: "DRIVER_DEFAULT")
      ConfigSystem.create_with(config_key: "CARRIER_DEFAULT", config_value: "1", config_description: "Transportadora padrão do sistema").find_or_create_by(config_key: "CARRIER_DEFAULT")
      OrdemService.where(id: [@ordem_service_ids]).update_all(status: OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
      result = Boardings::GenerateService.new(@ordem_service_ids).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Selected work ordem_service must be in status OPEN.")
    end

    it "when exist ordem service" do
      ConfigSystem.create_with(config_key: "DRIVER_DEFAULT", config_value: "1", config_description: "Motorista padrão do sistema").find_or_create_by(config_key: "DRIVER_DEFAULT")
      ConfigSystem.create_with(config_key: "CARRIER_DEFAULT", config_value: "1", config_description: "Transportadora padrão do sistema").find_or_create_by(config_key: "CARRIER_DEFAULT")
      BoardingItem.where(ordem_service_id: [@ordem_service_ids]).destroy_all
      OrdemService.where(id: [@ordem_service_ids]).update_all(status: OrdemService::TipoStatus::ABERTO)
      result = Boardings::GenerateService.new(@ordem_service_ids).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding created successfully.")
    end

  end
end
