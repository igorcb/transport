require 'rails_helper'

RSpec.describe Boardings::DeleteBoardingVehicleService, type: :service do
  context "delete" do
    before(:each) do
      @user = FactoryBot.create(:user)
      @vehicle = FactoryBot.create(:vehicle_tracao_bau)
      @boarding = FactoryBot.create(:boarding)
      @boarding_vehicle = @boarding.boarding_vehicles.create!(vehicle_id: @vehicle.id)
    end

    it "when the Boarding does not have the status OPEN" do
      @boarding.update_attributes(status: Boarding::TipoStatus::EMBARCADO)
      result = Boardings::DeleteBoardingVehicleService.new(@boarding_vehicle, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding does not have the status OPEN.")
    end

    it "when the Boarding have the status OPEN" do
      @boarding.update_attributes(status: Boarding::TipoStatus::ABERTO)
      result = Boardings::DeleteBoardingVehicleService.new(@boarding_vehicle, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding Vehicle delete successfully.")
    end
  end
end
