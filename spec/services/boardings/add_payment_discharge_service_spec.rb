require 'rails_helper'

RSpec.describe Boardings::AddPaymentDischargeService, type: :service do
  context "insert" do
    before(:each) do
      @user = FactoryBot.create(:user)
      @boarding = FactoryBot.create(:boarding)
    end

    it "when you do not have the driver" do
      driver = Driver.find(Boarding.driver_not_information)
      @boarding.driver_id = driver.id
      @boarding.save
      @boarding.reload
      result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding, please inform the driver.")
    end

    it "when have the driver" do
      driver = FactoryBot.create(:driver)
      carrier = FactoryBot.create(:carrier)
      @boarding.date_boarding = Date.current
      @boarding.driver_id = driver.id
      @boarding.carrier_id = carrier.id
      @boarding.save
      @boarding.reload
      @boarding.boarding_items.destroy_all
      @boarding.account_payables.destroy_all
      @ordem_service = FactoryBot.create(:ordem_service)
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::ABERTO)
      add_discharge_payment(@ordem_service)
      Boardings::AddBoardingItemService.new(@boarding, @ordem_service).call
      result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding, payment discharge created successfully.")
    end

    it "when you do not have the carrier" do
      carrier = Carrier.find(Boarding.carrier_not_information)
      @boarding.carrier_id = carrier.id
      @boarding.save
      @boarding.reload
      result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding, please inform the carrier.")
    end

    it "when have the carrier" do
      driver = FactoryBot.create(:driver)
      carrier = FactoryBot.create(:carrier)
      @boarding.date_boarding = Date.current
      @boarding.driver_id = driver.id
      @boarding.carrier_id = carrier.id
      @boarding.save
      @boarding.reload
      @boarding.boarding_items.destroy_all
      @boarding.account_payables.destroy_all
      @ordem_service = FactoryBot.create(:ordem_service)
      add_discharge_payment(@ordem_service)
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::ABERTO)
      Boardings::AddBoardingItemService.new(@boarding, @ordem_service).call
      result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding, payment discharge created successfully.")
    end

    it "when you do not have date boarding" do
      driver = FactoryBot.create(:driver)
      @boarding.driver_id = driver.id
      @boarding.date_boarding = nil
      @boarding.save
      @boarding.reload
      result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding, please inform the date boarding.")
    end

    it "when have the date boarding" do
      driver = FactoryBot.create(:driver)
      carrier = FactoryBot.create(:carrier)
      @boarding.date_boarding = Date.current
      @boarding.driver_id = driver.id
      @boarding.carrier_id = carrier.id
      @boarding.save
      @boarding.reload
      @boarding.boarding_items.destroy_all
      @boarding.account_payables.destroy_all
      @ordem_service = FactoryBot.create(:ordem_service)
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::ABERTO)
      add_discharge_payment(@ordem_service)
      Boardings::AddBoardingItemService.new(@boarding, @ordem_service).call
      result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding, payment discharge created successfully.")
    end

    it "when you do not have O.S." do
      driver = FactoryBot.create(:driver)
      carrier = FactoryBot.create(:carrier)
      @boarding.date_boarding = Date.current
      @boarding.driver_id = driver.id
      @boarding.carrier_id = carrier.id
      @boarding.save
      @boarding.reload
      @boarding.boarding_items.destroy_all
      result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding, not have O.S.")
    end

    it "when have the O.S." do
      driver = FactoryBot.create(:driver)
      carrier = FactoryBot.create(:carrier)
      @boarding.date_boarding = Date.current
      @boarding.driver_id = driver.id
      @boarding.carrier_id = carrier.id
      @boarding.save
      @boarding.reload
      @boarding.boarding_items.destroy_all
      @ordem_service = FactoryBot.create(:ordem_service)
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::ABERTO)
      add_discharge_payment(@ordem_service)
      Boardings::AddBoardingItemService.new(@boarding, @ordem_service).call
      result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding, payment discharge created successfully.")
    end

    it "when O.S. not have payment discharge" do
      driver = FactoryBot.create(:driver)
      carrier = FactoryBot.create(:carrier)
      @boarding.date_boarding = Date.current
      @boarding.driver_id = driver.id
      @boarding.carrier_id = carrier.id
      @boarding.save
      @boarding.reload
      @boarding.boarding_items.destroy_all
      @ordem_service = FactoryBot.create(:ordem_service)
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::ABERTO)
      Boardings::AddBoardingItemService.new(@boarding, @ordem_service).call
      result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding, please inform discharge payment all O.S.")
    end

    it "when all O.S. have payment discharge" do
      driver = FactoryBot.create(:driver)
      carrier = FactoryBot.create(:carrier)
      @boarding.date_boarding = Date.current
      @boarding.driver_id = driver.id
      @boarding.carrier_id = carrier.id
      @boarding.save
      @boarding.reload
      @boarding.boarding_items.destroy_all
      @ordem_service = FactoryBot.create(:ordem_service)
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::ABERTO)
      add_discharge_payment(@ordem_service)
      Boardings::AddBoardingItemService.new(@boarding, @ordem_service).call
      result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding, payment discharge created successfully.")
    end


    private
      def set_ordem_service_status(ordem_service, status)
        ordem_service.status = status
        ordem_service.save!
        ordem_service.reload
        ordem_service
      end

      def add_discharge_payment(ordem_service)
        discharge_payment = ordem_service.discharge_payments.create(type_operation_type: "OrdemService",
                                                                               type_unit: 1,
                                                                             type_charge: 1,
                                                                               type_calc: 1,
                                                                                   price: 1)
      end

   end
end
