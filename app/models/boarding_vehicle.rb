class BoardingVehicle < ActiveRecord::Base
  belongs_to :boarding, required: false
  belongs_to :vehicle, required: false

  default_scope -> { joins(:vehicle).order("vehicles.tipo desc").readonly(false) }

end
