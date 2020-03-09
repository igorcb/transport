FactoryBot.define do
  factory :palletizing_log do
    pallet_number { "20190101010000" }
    type_log { :input }
    historic { Faker::Lorem.word }
  end
end