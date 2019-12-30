class PalletizingPalletProduct < ApplicationRecord
  belongs_to :palletizing_pallet
  belongs_to :product
  belongs_to :nfe_xml, required: false
end
