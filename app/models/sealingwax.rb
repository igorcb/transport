class Sealingwax < ApplicationRecord
  belongs_to :boarding, class_name: "Boarding", foreign_key: "sealing_id", polymorphic: true, dependent: :destroy, required: false
  validates :sealing_id, uniqueness: { scope: [:sealing_type, :number], message: "can not have the same sealingwax for same boarding" }
end
