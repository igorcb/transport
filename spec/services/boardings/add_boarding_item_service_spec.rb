require 'rails_helper'

RSpec.describe Boardings::AddBoardingItemService, type: :service do
  context "insert" do
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
      @boarding = set_boarding_status(@boarding, Boarding::TipoStatus::EMBARCADO)
      result = Boardings::AddBoardingItemService.new(@boarding, @ordem_service, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding does not have the status OPEN.")
    end

    it "when the Boarding have the status OPEN" do
      @boarding = set_boarding_status(@boarding, Boarding::TipoStatus::ABERTO)
      result = Boardings::AddBoardingItemService.new(@boarding, @ordem_service, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding Items created successfully.")
      #expect { Counter.increment }.to change { Counter.count }.to(1)
    end

    it "when the Boarding does not have payment discharge" do
      @boarding.account_payables.destroy_all
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::ABERTO)
      result = Boardings::AddBoardingItemService.new(@boarding, @ordem_service, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding Items created successfully.")
    end

    it "when the Boarding has payment discharge" do
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::ABERTO)
      generate_account_payables(@boarding)
      result = Boardings::AddBoardingItemService.new(@boarding, @ordem_service, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding has payment discharge.")

    end

    it "when the O.S. does not exist" do
      @ordem_service = OrdemService.where(id: -1).first
      result = Boardings::AddBoardingItemService.new(@boarding, @ordem_service, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("O.S. does not exist.")
    end

    it "when the O.S. does not have the status OPEN" do
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
      result = Boardings::AddBoardingItemService.new(@boarding, @ordem_service, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("O.S. does not have the status OPEN.")
    end

    it "when the O.S. have the status OPEN" do
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::ABERTO)
      result = Boardings::AddBoardingItemService.new(@boarding, @ordem_service, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding Items created successfully.")
      #expect { Counter.increment }.to change { Counter.count }.to(1)
    end

    it "when the O.S. have the status WAITING BOARDING" do
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::ABERTO)
      result = Boardings::AddBoardingItemService.new(@boarding, @ordem_service, @user).call
      expect(@ordem_service.reload.status).to equal(OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding Items created successfully.")
    end

    it "when the O.S. be duplicated" do
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::ABERTO)
      result = Boardings::AddBoardingItemService.new(@boarding, @ordem_service, @user).call
      result = Boardings::AddBoardingItemService.new(@boarding, @ordem_service, @user).call
      expect(@ordem_service.reload.status).to equal(OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("O.S. be duplicated on boarding.")
    end

    private
      def set_boarding_status(boarding, status)
        boarding.status = status
        boarding.save
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
end
