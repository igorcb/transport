class MovementActivity < ActiveRecord::Base
  belongs_to :supplier
  belongs_to :activity
end
