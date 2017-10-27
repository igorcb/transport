# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :offer_driver do
    offer_charge nil
    date_incoming "2017-10-26"
    time_incoming "2017-10-26 11:04:54"
    driver "MyString"
    type_vehicle "MyString"
    place_horse "MyString"
    place_cart_first "MyString"
    place_cart_second "MyString"
    status 1
  end
end
