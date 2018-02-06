# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    employees nil
    name "MyString"
    body "MyText"
    start_date "2018-02-06"
    finish_date "2018-02-06"
    time_first 1
    allocated 1
    allocated_observation "MyText"
    second_time 1
    status 1
    observation "MyText"
  end
end
