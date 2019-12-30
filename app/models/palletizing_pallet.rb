class PalletizingPallet < ApplicationRecord
  belongs_to :palletizing
  has_many :palletizing_pallet_products, dependent: :destroy
  enum type_pallet: [:exclusive, :mixed, :leftover]

  def qtde_sku
    palletizing_pallet_products.count
  end

  def qtde_items
    palletizing_pallet_products.sum(:qtde)
  end

  def weight
    palletizing_pallet_products.joins(:product).sum(:weight_liquid)
  end
end
