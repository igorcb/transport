class AnttsVehicles < ActiveRecord::Base
  belongs_to :antt
  belongs_to :vehicle
end
