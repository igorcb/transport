class Ownership < ActiveRecord::Base
  belongs_to :vehicle, required: false
  belongs_to :owner, required: false
end
