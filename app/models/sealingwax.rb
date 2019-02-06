class Sealingwax < ApplicationRecord
  belongs_to :boarding, class_name: "Boarding", foreign_key: "sealing_id", polymorphic: true, dependent: :destroy, required: false
end
