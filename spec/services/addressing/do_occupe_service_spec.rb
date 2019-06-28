require 'rails_helper'

RSpec.describe Addressing::DoOccupeService, type: :service do

  it "when not exist a house" do
    result = Addressing::DoOccupeService.new(nil).call
    expect(result[:success]).to be_falsey
    expect(result[:message]).to match("Deposit does not exist.")
  end

  it "when exist a house" do
    byebug
    warehouse = Warehouse.create!(name: "a", address: "Address fake", number: "100", district: "district fake", city: "city fake", state: "state fake", zip_code: "60000-000" )
    deposit = warehouse.deposits.create!(name: "1")
    street = deposit.streets.create!(name: "1")
    floor = street.floors.create!(name: "1")
    house = floor.houses.create!(name: "1")

    result = Addressing::DoOccupeService.new(house).call
    expect(result[:success]).to be_truthy
    expect(result[:message]).to match("house does not exist.")
  end
end
