class Driving < ActiveRecord::Base
  belongs_to :driver, required: false
  belongs_to :vehicle, required: false
end
