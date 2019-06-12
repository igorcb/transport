class Deposit < ApplicationRecord
  belongs_to :warehouse

  validates :warehouse, :name, presence: true
end
