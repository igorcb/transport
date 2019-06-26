FactoryBot.define do
  factory :shipper do
    name  { Faker::Lorem.word }
    cnpj   { Faker::CNPJ.cnpj }
  end
end
