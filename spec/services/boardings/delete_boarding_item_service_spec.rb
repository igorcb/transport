require 'rails_helper'

RSpec.describe Boardings::DeleteBoardingItemService, type: :service do
  context "delete" do
    before(:each) do
      #byebug
      @user = FactoryBot.create(:user)
      @client = FactoryBot.create(:client)
      @source_client = FactoryBot.create(:client)
      @driver = FactoryBot.create(:driver)
      @carrier = FactoryBot.create(:carrier)
      @boarding = FactoryBot.create(:boarding)
      @ordem_service = FactoryBot.create(:ordem_service)
    end

    it "when the Boarding does not have the status OPEN" do
      #@boarding.account_payables.destroy_all
      @boarding = set_boarding_status(@boarding, Boarding::TipoStatus::EMBARCADO)
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
      result = Boardings::DeleteBoardingItemService.new(@boarding, @ordem_service, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding does not have the status OPEN.")
    end

    it "when the Boarding have the status OPEN" do
      @boarding.account_payables.destroy_all
      @boarding = set_boarding_status(@boarding, Boarding::TipoStatus::ABERTO)
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
      #@ordem_service = set_ordem_service_status(@boarding, Boarding::TipoStatus::ABERTO)
      result = Boardings::DeleteBoardingItemService.new(@boarding, @ordem_service, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding Items delete successfully.")
    end

    it "when the Boarding does not have payment discharge" do
      @boarding.account_payables.destroy_all
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
      result = Boardings::DeleteBoardingItemService.new(@boarding, @ordem_service, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding Items delete successfully.")
    end

    it "when the Boarding has payment discharge" do
      @boarding.account_payables.destroy_all
      generate_account_payables(@boarding)
      result = Boardings::DeleteBoardingItemService.new(@boarding, @ordem_service, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding has payment discharge.")
    end

    it "when the O.S. does not have the status AGUARDANDO_EMBARQUE" do
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::ENTREGA_EFETUADA)
      result = Boardings::DeleteBoardingItemService.new(@boarding, @ordem_service, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("O.S. does not have the status AGUARDANDO_EMBARQUE.")
    end

    it "when the O.S. have the status  AGUARDANDO_EMBARQUE" do
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
      result = Boardings::DeleteBoardingItemService.new(@boarding, @ordem_service, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding Items delete successfully.")
    end
  end

  private
    def set_boarding_status(boarding, status)
      boarding.status = status
      boarding.save!
      boarding.reload
      boarding
    end

    def set_ordem_service_status(ordem_service, status)
      ordem_service.status = status
      ordem_service.save!
      ordem_service.reload
      ordem_service
    end

    def generate_account_payables(boarding)
      account_payable = boarding.account_payables.build
      account_payable.type_account = AccountPayable::TypeAccount::DRIVER
      account_payable.supplier_type = "Driver"
      account_payable.supplier_id = @boarding.driver_id
      account_payable.cost_center_id = ConfigSystem.where(config_key: 'PAYMENT_DISCHARGE_COST_CENTER').first.config_value
      account_payable.sub_cost_center_id = ConfigSystem.where(config_key: 'PAYMENT_DISCHARGE_SUB_COST_CENTER').first.config_value
      account_payable.sub_cost_center_three_id = ConfigSystem.where(config_key: 'PAYMENT_DISCHARGE_SUB_COST_CENTER_THREE').first.config_value
      account_payable.payment_method_id = ConfigSystem.where(config_key: 'PAYMENT_METHOD_DEFAULT').first.config_value
      account_payable.historic_id = ConfigSystem.where(config_key: 'HISTORIC_DEFAULT').first.config_value
      account_payable.data_vencimento = Date.today
      account_payable.documento = "#{@boarding.id}"
      account_payable.valor = 100.00 #fazer o calculo do pagamento de descarga
      account_payable.observacao = "TESTE AUTOMATIZADO, PAGAMENTO DE DESCARGA DO EMBARQUE"
      account_payable.user_created_id = @user.id
      account_payable.status = AccountPayable::TipoStatus::ABERTO
      account_payable.save!
    end
end
