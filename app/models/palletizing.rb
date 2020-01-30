class Palletizing < ApplicationRecord
  validates :input_control, uniqueness: true

  belongs_to :input_control
  belongs_to :user, foreign_key: 'user_created_id'
  has_many :palletizing_pallets, dependent: :destroy

  enum view_mode: [:by_customer, :by_nfe, :single]
  enum status: [:started, :finished]
  enum type_product: [:pallet, :chapatex, :big_bag]

end
