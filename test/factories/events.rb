# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    user nil
    controller_name "MyString"
    action_name "MyString"
    what "MyText"
  end
end
