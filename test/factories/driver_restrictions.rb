# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :driver_restriction do
    client nil
    restriction 1
    observation "MyText"
  end
end
