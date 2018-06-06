# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client_discharge do
    client_source nil
    type_unit 1
    type_charge 1
    type_calc 1
    value "9.99"
  end
end
