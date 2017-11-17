# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :config_system do
    config_key "MyString"
    config_value "MyString"
    config_description "MyText"
  end
end
