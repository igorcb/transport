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

  def weight_liquid
    palletizing_pallet_products.joins(:product).sum("products.weight_liquid * palletizing_pallet_products.qtde")
  end

  def weight_gross
    palletizing_pallet_products.joins(:product).sum("products.weight_gross * palletizing_pallet_products.qtde")
  end
end
