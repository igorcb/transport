# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    recipient_id 1
    actor_id 1
    read_at "2018-10-09 15:41:18"
    action "MyString"
    notifiable_id 1
    notifiable_type "MyString"
  end
end
