FactoryBot.define do
  factory :conference do
    type_operation { "MyString" }
    conference { "" }
    date_conference { "2019-09-16" }
    start_time { "2019-09-16 13:08:40" }
    finish_time { "MyString" }
    status { "MyString" }
    approved { false }
    user { nil }
  end
end
