require_relative '../place_helper'

FactoryBot.define do
  factory :direct_charge do
    place { PlaceHelper.faker_place }
    shipment {"SIM-#{Faker::Number.leading_zero_number(10)}"  }
    date_charge {Date.current}
    carrier
    driver
    status {Boarding::TipoStatus::ABERTO}
  end
end
