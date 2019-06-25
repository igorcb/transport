require 'rails_helper'

RSpec.describe Addressing::GeneratorService, type: :service do
  before(:each) do
    @deposit = FactoryBot.create(:deposit)
  end

  it "when not exist a deposit" do
    result = Addressing::GeneratorService.new(deposit_id: nil).call
    expect(result[:success]).to be_falsey
    expect(result[:message]).to match("Deposit does not exist.")
  end

  it "when exist a deposit" do
    result = Addressing::GeneratorService.new(deposit_id: @deposit.id, initStreet: 1, endStreet: 1, maxFloor: 1, maxHouse: 1, spaceHouse: 1).call
    expect(result[:success]).to be_truthy
    expect(result[:message]).to match("Generation Houses created successfully.")
  end

  it "when iniStreet or endStreet are empty" do
    result = Addressing::GeneratorService.new(deposit_id: @deposit.id, initStreet: nil, endStreet: nil, maxFloor: 1, maxHouse: 1, spaceHouse: 1).call
    expect(result[:success]).to be_falsey
    expect(result[:message]).to match("initStreet or endStreet are empty.")
  end

  it "when endStreet can not less than initStreet" do
    result = Addressing::GeneratorService.new(deposit_id: @deposit.id, initStreet: 3, endStreet: 1, maxFloor: 1, maxHouse: 1, spaceHouse: 1).call
    expect(result[:success]).to be_falsey
    expect(result[:message]).to match("initStreet can not great than endStreet")
  end

  it "when initStreet and endStreet are populated." do
    result = Addressing::GeneratorService.new(deposit_id: @deposit.id, initStreet: 1, endStreet: 1, maxFloor: 1, maxHouse: 1, spaceHouse: 1).call
    expect(result[:success]).to be_truthy
    expect(result[:message]).to match("Generation Houses created successfully.")
  end

  it "when maxFloor are empty" do
    result = Addressing::GeneratorService.new(deposit_id: @deposit.id, initStreet: 1, endStreet: 1, maxFloor: nil, maxHouse: 1, spaceHouse: 1).call
    expect(result[:success]).to be_falsey
    expect(result[:message]).to match("maxFloor are empty.")
  end

  it "when maxFloor are populated" do
    result = Addressing::GeneratorService.new(deposit_id: @deposit.id, initStreet: 1, endStreet: 1, maxFloor: 1, maxHouse: 1, spaceHouse: 1).call
    expect(result[:success]).to be_truthy
    expect(result[:message]).to match("Generation Houses created successfully.")
  end

  # it 'count qtde houses' do
  #   result = Addressing::GeneratorService.new(deposit_id: @deposit.id, initStreet: 1, endStreet: 1, maxFloor: 1, maxHouse: 1, spaceHouse: 1).call
  #   expect(result[:success]).to be_truthy
  #   expect(result[:message]).to match("Generation Houses created successfully.")
  #   expect { create_house }.to change { House.count }.by(1)
  # end

end
