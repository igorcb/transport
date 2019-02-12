class VehicleRestriction < ApplicationRecord
  belongs_to :vehicle, required: false
  validates :vehicle_id, presence: true
  validates :motive_id, presence: true

  enum motive_id: { suitable_floor: 0, overweight: 1 }
  enum status: { locking: 0, unlocking: 1}

  before_save do |v|
    v.status = 0
  end

  def self.vehicle_loking?(vehicle_id)
    VehicleRestriction.locking.where(vehicle_id: vehicle_id).present?
  end

  def self.unlock(vehicle_restriction)
    VehicleRestriction.where(id: vehicle_restriction.id).update_all(status: 1)
  end

  def self.check_places_loking?(places)
    positivo = false
    places.each do |place|
      vehicle = Vehicle.where(placa: place).first
      if vehicle.blank?
        positivo = false
        return positivo
      else
        positivo = VehicleRestriction.vehicle_loking?(vehicle.id)
        return positivo
      end
    end
    positivo
  end

end

# placa cavalo - tem Restricao
# placa carreta - não tem restricao

# se a placa não existe sai do loop
# assim que achar a restrição no primeiro item sair do loop
