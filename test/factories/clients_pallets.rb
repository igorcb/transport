# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :clients_pallet do
    client nil
    product nil
    layer_pallet "9.99"
  end
end
