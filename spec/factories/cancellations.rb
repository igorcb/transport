# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cancellation do
    solicitation_user_id 1
    authorization_user_id 1
    status 1
    observacao "Vestibulum iaculis"
    cancel nil
  end
end
