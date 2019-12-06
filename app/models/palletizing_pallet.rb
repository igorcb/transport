class PalletizingPallet < ApplicationRecord
  belongs_to :palletizing
  has_many :palletizing_pallet_products
end
