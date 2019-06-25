FactoryBot.define do
 factory :warehouse do
    name     { Faker::Lorem.word }
    zip_code { Faker::Address::zip_code }
    address { Faker::Address.street_name }
    number { Faker::Address.building_number }
    district { Faker::Lorem.word }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
 end
end
