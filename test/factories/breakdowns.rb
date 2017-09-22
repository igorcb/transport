# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :breakdown do
    input_control nil
    type_breakdown 1
    sobras 1
    faltas 1
    avarias 1
  end
end
