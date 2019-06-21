class House < ApplicationRecord
  belongs_to :floor
  delegate :warehouse, to: :deposit
  delegate :deposit, to: :street
  delegate :street, to: :floor

  validates :name, :floor, presence: true
end
