class VehicleRestriction < ApplicationRecord
  belongs_to :vehicle, required: false
  validates :vehicle_id, presence: true
  validates :motive_id, presence: true

  enum motive_id: { suitable_floor: 0, overweight: 1 }
  enum status: { locking: 0, unlocking: 1}

  before_save do |v|
    v.status = 0
  end

  def self.vehicle_loking?(vehicle_id)
    VehicleRestriction.locking.where(vehicle_id: vehicle_id).present?
  end

  def self.unlock(vehicle_restriction)
    VehicleRestriction.where(id: vehicle_restriction.id).update_all(status: 1)
  end
end
