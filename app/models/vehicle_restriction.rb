class VehicleRestriction < ApplicationRecord
  belongs_to :vehicle, required: false
  validates :vehicle_id, presence: true
  validates :motive_id, presence: true

  enum motive_id: { suitable_floor: 0, overweight: 1 }
end
