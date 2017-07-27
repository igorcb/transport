# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :state do
    code_uf 1
    name "MyString"
    uf "MyString"
    region nil
  end
end
