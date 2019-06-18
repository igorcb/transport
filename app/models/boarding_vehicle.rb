class BoardingVehicle < ActiveRecord::Base
  belongs_to :boarding, required: false
  belongs_to :vehicle, required: false

  validates :boarding_id, uniqueness: { scope: :vehicle_id, message: "can not have the same vehicle for same boarding" }

end
