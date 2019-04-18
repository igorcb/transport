FactoryBot.define do
  factory :discharge_payment do
    discharge_payment { "" }
    type_operation { "MyString" }
    type_unit { "MyString" }
    type_charge { "MyString" }
    type_calc { "MyString" }
    price { "9.99" }
  end
end
