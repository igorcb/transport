class BoardingVehicle < ActiveRecord::Base
  belongs_to :boarding
  belongs_to :vehicle
end
