# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :table_insurance do
    insurer nil
    state_source "MyString"
    state_target "MyString"
    percent "9.99"
  end
end
