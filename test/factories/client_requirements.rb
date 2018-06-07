# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client_requirement do
    client nil
    client_source_id 1
    type_vehicle 1
    type_body 1
    type_floor 1
  end
end
