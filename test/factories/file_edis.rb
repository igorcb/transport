# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :file_edi do
    type_file "MyString"
    date_file "2018-08-30"
    name_file "MyString"
    file "MyString"
    content "MyText"
  end
end
