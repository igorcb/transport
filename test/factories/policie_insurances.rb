# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :policie_insurance do
    insurer nil
    borker nil
    proposal "MyString"
    policy "MyString"
    date_expired "2018-09-18"
    value "9.99"
  end
end
