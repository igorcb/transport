# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :table_freight do
    type_charge "MyString"
    km_from 1
    km_to 1
    price "9.99"
  end
end
