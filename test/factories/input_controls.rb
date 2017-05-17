# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :input_control do
    carrier nil
    driver nil
    date_entry "2017-05-17"
    time_entry "2017-05-17 10:25:59"
    date_receipt "2017-05-17"
    value_ton "9.99"
    value_kg "9.99"
    valor_total "9.99"
    observation "MyText"
  end
end
