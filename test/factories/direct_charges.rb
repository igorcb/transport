# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :direct_charge do
    carrier nil
    driver nil
    place "MyString"
    place_cart "MyString"
    place_cart2 "MyString"
    date_charge "2017-07-26"
    palletized false
    quantity_pallets 1
    weight "9.99"
    volume "MyString"
    decimal "MyString"
    observation "MyText"
    user nil
    source_state_id 1
    source_city_id 1
    target_state_id 1
    target_city_id 1
  end
end
