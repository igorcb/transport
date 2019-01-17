FactoryBot.define do
  factory :vehicle_restriction do
    vehicle { nil }
    motive_id { 1 }
    movive_observation { "MyText" }
    status { 1 }
  end
end
