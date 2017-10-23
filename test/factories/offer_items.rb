# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :offer_item do
    city "MyString"
    state "MyString"
    client "MyString"
    date_schedule "2017-10-23"
    time_shedule "2017-10-23 14:55:33"
    qtde_pallets 1
    volume "9.99"
    weight "9.99"
  end
end
