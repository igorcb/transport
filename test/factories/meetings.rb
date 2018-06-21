# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :meeting do
    date_event "2018-06-21"
    local "MyString"
    summoned "MyString"
    facilitator "MyString"
    secretary "MyString"
    objective "MyText"
  end
end
