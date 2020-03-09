class Street < ApplicationRecord
  belongs_to :deposit
  has_many :floors, dependent: :destroy
  delegate :warehouse, to: :deposit

  validates :deposit, presence: true
  validates :name, presence: true, uniqueness: { scope: :deposit, message: "should happen once per deposit", case_sensitive: false }
end
