# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :advance_money do
    date_advance "2018-04-16"
    number "MyString"
    price "9.99"
  end
end
