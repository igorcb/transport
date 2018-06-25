# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subject_answer do
    subject nil
    deadline "2018-06-25"
    responsible "MyString"
    action "MyText"
  end
end
