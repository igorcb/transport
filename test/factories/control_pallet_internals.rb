# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :control_pallet_internal do
    responsable_type "MyString"
    responsable_id 1
    type_launche 1
    date_launche "2017-06-30"
    qtde 1
    historic "MyString"
    observation "MyText"
  end
end
