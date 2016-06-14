# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sub_cost_center_three do
    cost_center nil
    sub_cost_center nil
    descricao "MyString"
  end
end
