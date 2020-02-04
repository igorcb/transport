class PalletizingPallet < ApplicationRecord
  belongs_to :palletizing
  belongs_to :user
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

  def nfes
    palletizing_pallet_products.select("DISTINCT nfe_xml_id").map{|p| p.nfe_xml.numero }
  end

  def products
    palletizing_pallet_products.select("DISTINCT product_id").map{|p| p.product }
  end

  def target_client
    palletizing_pallet_products.select("DISTINCT nfe_xml_id").map{|p| p.nfe_xml.target_client.fantasia }
  end
end
