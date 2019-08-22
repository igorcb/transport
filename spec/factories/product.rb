FactoryBot.define do
  factory :product do
    category
    descricao { Faker::Commerce.product_name }
    cubagem {0.00}
  end
end
