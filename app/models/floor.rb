class Floor < ApplicationRecord
  belongs_to :street
  delegate :deposit, to: :street
  delegate :warehouse, to: :deposit

end
