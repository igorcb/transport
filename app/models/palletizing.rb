class Palletizing < ApplicationRecord
  validates :input_control, uniqueness: true
  
  belongs_to :input_control
  has_many :paletizing_pallet

  enum view_mode: [:by_customer, :by_nfe, :single]
  enum palletizing: [:started, :finished]
end
