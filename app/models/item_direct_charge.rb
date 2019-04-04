class ItemDirectCharge < ApplicationRecord
  belongs_to :direct_charge, required: true
  belongs_to :product, required: true
  validates :number_nfe, presence: true
end
