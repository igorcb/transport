FactoryBot.define do
  factory :palletizing do
    view_mode { 1 }
    input_control
    user_created_id factory: :user
  end
end
