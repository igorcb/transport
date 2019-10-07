require 'rails_helper'

RSpec.describe Boardings::DeclinedService, type: :service do

  context "generate" do
    before(:each) do
      #byebug
      @user = FactoryBot.create(:user)
      @boarding = FactoryBot.create(:boarding)
      @ordem_service = FactoryBot.create(:ordem_service)
      @boarding_items = @boarding.boarding_items.create(ordem_service_id: @ordem_service.id, delivery_number: 1)
      @ordem_service.update_attributes(status: OrdemService::TipoStatus::EMBARCADO)
    end

    it "when boarding and user is not exist" do
      result = Boardings::DeclinedService.new(nil, nil).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding is not exist.")
    end

    it "when boarding and user is exist" do
      @boarding.boarding_items.destroy_all
      @boarding.update_attributes(status: Boarding::TipoStatus::EMBARCADO)
      result = Boardings::DeclinedService.new(@boarding, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding decliend successfully.")
    end

    it "when boarding the status is not EMBARCADO" do
      @boarding.update_attributes(status: Boarding::TipoStatus::ABERTO)
      result = Boardings::DeclinedService.new(@boarding, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding must be in status EMBARCADO.")
    end

    it "when boarding the status is EMBARCADO" do
      @boarding.boarding_items.destroy_all
      @boarding.update_attributes(status: Boarding::TipoStatus::EMBARCADO)
      result = Boardings::DeclinedService.new(@boarding, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding decliend successfully.")
    end

    it "when ordem service is not status EMBARCADO" do
      #puts ">>>>>>>>>>>>>>>>>>>>>>>>>> : #{@boarding.boarding_items.count} "
      @ordem_service = @boarding.boarding_items.first.ordem_service
      @ordem_service.update_attributes(status: OrdemService::TipoStatus::ABERTO)
      @boarding.update_attributes(status: Boarding::TipoStatus::EMBARCADO)
      result = Boardings::DeclinedService.new(@boarding, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Ordem Services to boarding must be in status EMBARCADO.")
    end

    it "when ordem service status is EMBARCADO" do
      #puts ">>>>>>>>>>>>>>>>>>>>>>>>>> : #{@boarding.boarding_items.count} "
      @ordem_service = @boarding.boarding_items.first.ordem_service
      @ordem_service.update_attributes(status: OrdemService::TipoStatus::EMBARCADO)
      @boarding.update_attributes(status: Boarding::TipoStatus::EMBARCADO)
      result = Boardings::DeclinedService.new(@boarding, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding decliend successfully.")
    end

    # it "when not removing the ordem service in boarding" do
    #   @boarding.update_attributes(status: Boarding::TipoStatus::EMBARCADO)
    #   result = Boardings::DeclinedService.new(@boarding, @user).call
    #   expect(result[:success]).to be_falsey
    #   expect(result[:message]).to match("Boarding it not remove ordem services.")
    # end
  end
end
