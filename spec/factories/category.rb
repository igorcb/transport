FactoryBot.define do
  factory :category do
    descricao { Faker::Commerce.material }
  end
end
