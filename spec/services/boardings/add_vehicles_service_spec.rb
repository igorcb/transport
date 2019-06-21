require 'rails_helper'

RSpec.describe Boardings::AddVehiclesService, type: :service do
  #context "insert TRACAO or REBOQUE" do
  context "insert" do
    before(:each) do
      @boarding = FactoryBot.create(:boarding)
      @vehicle_not_exist = Vehicle.where(id: -1) #FactoryBot.create(:vehicle)
      @vehicle_tracao = FactoryBot.create(:vehicle_tracao)
      @vehicle_reboque = FactoryBot.create(:vehicle_reboque)
    end

    it "when do not have a vehicle" do
      result = Boardings::AddVehiclesService.new(@boarding, @vehicle_not_exist).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding, vehicle does not exist.")
    end

    it "when have a vehicle" do
      result = Boardings::AddVehiclesService.new(@boarding, @vehicle_tracao).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding, vehicle created successfully.")
    end

    it "when two vehicles are alike" do
      @boarding.boarding_vehicles.create(vehicle_id: @vehicle_tracao.id)
      result = Boardings::AddVehiclesService.new(@boarding, @vehicle_tracao).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding, must have at least one vehicle.")
    end

    it "when two vehicles are different" do
      @vehicle_tracao_other = FactoryBot.create(:vehicle_tracao)
      result = Boardings::AddVehiclesService.new(@boarding, @vehicle_tracao_other).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding, vehicle created successfully.")
    end

    it "when two vehicles are alike" do
      @boarding.boarding_vehicles.create(vehicle_id: @vehicle_tracao.id)
      result = Boardings::AddVehiclesService.new(@boarding, @vehicle_tracao).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding, must have at least one vehicle.")
    end

    it "when the first vehicle is TRACAO, the second must be TRACAO (TRACAO, TRACAO)" do
      @vehicle_tracao_second = FactoryBot.create(:vehicle_tracao)
      @boarding.boarding_vehicles.create(vehicle_id: @vehicle_tracao.id)
      result = Boardings::AddVehiclesService.new(@boarding, @vehicle_tracao_second).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding, vehicles are of the same type.")
    end

    it "when the first vehicle is REBOQUE, the second must be REBOQUE (REBOQUE, REBOQUE)" do
      @vehicle_reboque_second = FactoryBot.create(:vehicle_reboque)
      @boarding.boarding_vehicles.create(vehicle_id: @vehicle_reboque.id)
      result = Boardings::AddVehiclesService.new(@boarding, @vehicle_reboque_second).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding, vehicles are of the same type.")
    end

    it "when the first vehicle is TRACAO, the second must be REBOQUE (TRACAO, REBOQUE)" do
      @vehicle_second_reboque = FactoryBot.create(:vehicle_reboque)
      @boarding.boarding_vehicles.create(vehicle_id: @vehicle_tracao.id)
      result = Boardings::AddVehiclesService.new(@boarding, @vehicle_second_reboque).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Boarding, vehicle created successfully.")
    end

    it "when the first vehicle is TRACAO_BAU, you can not have another type of vehicle" do
      @vehicle_tracao_bau = FactoryBot.create(:vehicle_tracao_bau)
      @vehicle_tracao_bau_other = FactoryBot.create(:vehicle_reboque)
      @boarding.boarding_vehicles.create(vehicle_id: @vehicle_tracao_bau.id)
      result = Boardings::AddVehiclesService.new(@boarding, @vehicle_tracao_bau_other).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding, you can not have another type of vehicle.")
    end

    it "when the first vehicle is TRACAO and REBOQUE, must not accept vehicles" do
      @vehicle_tracao_bau_other = FactoryBot.create(:vehicle_tracao_bau)
      @boarding.boarding_vehicles.create(vehicle_id: @vehicle_tracao.id)
      @boarding.boarding_vehicles.create(vehicle_id: @vehicle_reboque.id)
      result = Boardings::AddVehiclesService.new(@boarding, @vehicle_tracao_bau_other).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Boarding, you already have the types of vehicles.")
    end
  end

end
