class Deposit < ApplicationRecord
  belongs_to :warehouse
  has_many :street

  validates :warehouse, presence: true
  validates :name, presence: true, uniqueness: { scope: :warehouse, message: "should happen once per warehouse", case_sensitive: false }
end
