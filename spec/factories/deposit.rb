FactoryBot.define do
 factory :deposit do
    name     { Faker::Lorem.word }
    warehouse
 end
end
