class BoardingVehicle < ActiveRecord::Base
  belongs_to :boarding, required: false
  belongs_to :vehicle, required: false

  validates :boarding_id, uniqueness: { scope: :vehicle_id, message: "can not have the same vehicle for same boarding" }
  #validate  :check_two_vehicles
  #validate  :check_two_vehicles_tracao_and_reboque?
  #default_scope -> { joins(:vehicle).order("vehicles.tipo desc").readonly(false) }

  # def two_vehicles_differ
  #   #if cnh_expired?
  #     errors.add(:validade_cnh, "expiration")
  #   #end
  # end
  #
  # def check_two_vehicles
  #   vehicle = Vehicle.where(id: self.vehicle_id).first
  #   boarding = Boarding.where(id: self.boarding_id).first
  #   boarding.boarding_vehicles.joins(:vehicle).where( vehicles: {tipo: vehicle.tipo}).present?
  # end


end
