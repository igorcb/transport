class AnttsVehicles < ActiveRecord::Base
  belongs_to :antt, required: false
  belongs_to :vehicle, required: false
end
