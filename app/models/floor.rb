class Floor < ApplicationRecord
  belongs_to :street
  has_many :house
  delegate :deposit, to: :street
  delegate :warehouse, to: :deposit

end
