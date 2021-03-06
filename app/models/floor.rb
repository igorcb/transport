class Floor < ApplicationRecord
  belongs_to :street
  has_many :houses, dependent: :destroy
  delegate :deposit, to: :street
  delegate :warehouse, to: :deposit

end
