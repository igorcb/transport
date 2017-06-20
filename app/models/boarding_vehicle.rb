class BoardingVehicle < ActiveRecord::Base
  belongs_to :boarding
  belongs_to :vehicle

  default_scope -> { joins(:vehicle).order("vehicles.tipo desc") }

end
