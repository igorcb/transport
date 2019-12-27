class Palletizing < ApplicationRecord
  validates :input_control, uniqueness: true

  belongs_to :input_control
  has_many :palletizing_pallets, dependent: :destroy

  enum view_mode: [:by_customer, :by_nfe, :single]
  enum status: [:started, :finished]

end
