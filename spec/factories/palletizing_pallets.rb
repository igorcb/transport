FactoryBot.define do
  factory :palletizing_pallet do
    number { "20190101010000" }
    type_pallet { :exclusive }
    palletizing
    user
  end
end
