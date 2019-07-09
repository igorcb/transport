require 'rails_helper'

RSpec.describe Boardings::AddPaymentDischargeService, type: :service do
  context "insert" do
    before(:each) do
      @user = FactoryBot.create(:user)
      @driver = FactoryBot.create(:driver)
      @carrier = FactoryBot.create(:carrier)
      @boarding = FactoryBot.create(:boarding)
    end

    it "when you do not have the driver" do
      driver = Driver.find(Boarding.driver_not_information)
      @boarding.update_attributes(driver_id: driver.id)
      result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding, please inform the driver.")
    end

    it "when have the driver" do
      @boarding.update_attributes(driver_id: @driver.id, carrier_id: @carrier.id, date_boarding: Date.current)
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
      @boarding.update_attributes(carrier_id: carrier.id)
      result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding, please inform the carrier.")
    end

    it "when have the carrier" do
      @boarding.update_attributes(driver_id: @driver.id, carrier_id: @carrier.id, date_boarding: Date.current)
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
      @boarding.update_attributes(driver_id: @driver.id, carrier_id: @carrier.id, date_boarding: nil)
      result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding, please inform the date boarding.")
    end

    it "when have the date boarding" do
      @boarding.update_attributes(driver_id: @driver.id, carrier_id: @carrier.id, date_boarding: Date.current)
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
      @boarding.update_attributes(driver_id: @driver.id, carrier_id: @carrier.id, date_boarding: Date.current)
      @boarding.boarding_items.destroy_all
      result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding, not have O.S.")
    end

    it "when have the O.S." do
      @boarding.update_attributes(driver_id: @driver.id, carrier_id: @carrier.id, date_boarding: Date.current)
      @boarding.boarding_items.destroy_all
      @ordem_service = FactoryBot.create(:ordem_service)
      @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::ABERTO)
      add_discharge_payment(@ordem_service)
      Boardings::AddBoardingItemService.new(@boarding, @ordem_service).call
      result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding, payment discharge created successfully.")
    end

    # it "when O.S. not have payment discharge" do
    #   @boarding.update_attributes(driver_id: @driver.id, carrier_id: @carrier.id, date_boarding: Date.current)
    #   @boarding.boarding_items.destroy_all
    #   @ordem_service = FactoryBot.create(:ordem_service)
    #   @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::ABERTO)
    #   Boardings::AddBoardingItemService.new(@boarding, @ordem_service).call
    #   result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
    #   expect(result[:success]).to be_falsey
    #   expect(result[:message]).to match("Boarding, please inform discharge payment all O.S.")
    # end
    #
    # it "when all O.S. have payment discharge" do
    #   driver = FactoryBot.create(:driver)
    #   carrier = FactoryBot.create(:carrier)
    #   @boarding.date_boarding = Date.current
    #   @boarding.driver_id = driver.id
    #   @boarding.carrier_id = carrier.id
    #   @boarding.save
    #   @boarding.reload
    #   @boarding.boarding_items.destroy_all
    #   @ordem_service = FactoryBot.create(:ordem_service)
    #   @ordem_service = set_ordem_service_status(@ordem_service, OrdemService::TipoStatus::ABERTO)
    #   add_discharge_payment(@ordem_service)
    #   Boardings::AddBoardingItemService.new(@boarding, @ordem_service).call
    #   result = Boardings::AddPaymentDischargeService.new(@boarding, @user).call
    #   expect(result[:success]).to be_truthy
    #   expect(result[:message]).to match("Boarding, payment discharge created successfully.")
    # end


    private
      def set_ordem_service_status(ordem_service, status)
        ordem_service.status = status
        ordem_service.save!
        ordem_service.reload
        ordem_service
      end

      def add_discharge_payment(ordem_service)
        discharge_payment = ordem_service.discharge_payments.create(type_operation_type: "OrdemService",
                                                                               type_unit: DischargePayment.type_units[:burden],
                                                                             type_charge: DischargePayment.type_charges[:palletized],
                                                                               type_calc: DischargePayment.type_calcs[:weight],
                                                                                   price: 1.00)
      end

   end
end
