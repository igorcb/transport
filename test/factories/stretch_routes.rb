# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stretch_route do
    stretch_source_id 1
    streatch_target_id 1
    tax_rate "9.99"
    non_tax_rate "9.99"
    secure_rate "9.99"
    secure_rate_filch "9.99"
    secure_rate_aggravated "9.99"
    travel_time 1
    distance 1
    cost_kg "9.99"
    tax_iss "9.99"
  end
end
