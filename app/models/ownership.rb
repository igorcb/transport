class Ownership < ActiveRecord::Base
  belongs_to :vehicle
  belongs_to :owner
end
