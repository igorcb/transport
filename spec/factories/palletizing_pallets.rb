FactoryBot.define do
  factory :palletizing_pallet do
    number { 1 }
    type { 1 }
    palletizing { nil }
    qtde_sku { 1 }
    qtde_items { 1 }
  end
end
