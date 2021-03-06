class House < ApplicationRecord
  belongs_to :floor
  belongs_to :palletizing_pallet, required: false
  
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

  def address
    ".#{self.floor.street.deposit.warehouse.name}.#{self.floor.street.deposit.name}.#{self.floor.street.name}.#{self.floor.name}.#{self.name}"    
  end
  
end
