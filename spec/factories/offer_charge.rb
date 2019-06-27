FactoryBot.define do
  factory :offer_charge do
    shipper
    date_shipment {Date.current}
    shipping {"REM-#{Faker::Number.leading_zero_number(10)}"  }
    local_loading {Faker::Address.city}
    local_landing {Faker::Address.city}
    type_vehicle {"BAU, GRANELEIRO, SIDER"}
  end
end
