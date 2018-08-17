# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :file_occurrence do
    client nil
    date_file "2018-08-17"
    name_file "MyString"
    content "MyText"
  end
end
