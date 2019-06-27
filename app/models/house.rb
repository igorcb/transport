class House < ApplicationRecord
  belongs_to :floor
  delegate :warehouse, to: :deposit
  delegate :deposit, to: :street
  delegate :street, to: :floor

  validates :name, :floor, presence: true
  enum actived: {active: true, no_active: false}
  enum occupied: {occuped: true, no_occuped: false}

  before_create do |item|
    item.actived = true
  end

  def self.occupied_percent
    House.active.count * House.active.occuped.count / 100
  end
end
