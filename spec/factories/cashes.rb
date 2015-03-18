# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cash do
    data "2015-03-18"
    valor "9.99"
    tipo 1
    payment_method nil
    cost_center nil
    sub_cost_center nil
    historic nil
  end
end
