class MovementActivity < ActiveRecord::Base
  belongs_to :supplier, required: false
  belongs_to :activity, required: false
end
