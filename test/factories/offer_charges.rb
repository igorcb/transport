# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :offer_charge do
    shipper "MyString"
    date_shipment "2017-10-23"
    shipping "MyString"
    local_loading "MyString"
    city "MyString"
    state "MyString"
    client "MyString"
    date_schedule "2017-10-23"
    type_vehicle "MyString"
    vehicle_detail "MyString"
    vehicle_situation 1
    qtde_pallets 1
    volume "9.99"
    weight "9.99"
    value_nf "9.99"
    state 1
  end
end
