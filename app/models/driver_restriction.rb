class DriverRestriction < ActiveRecord::Base
	validates :client_id, presence: true
	validates :restriction, presence: true

	belongs_to :driver, required: false
  belongs_to :client, required: false

	enum status: { locking: 0, unlocking: 1}

	before_save do |v|
    v.status = 0
  end

  module TypeRestriction
  	CARGA = 0
  	CLIENTE = 1
  	SEGURADORA = 2
  end

  def restriction_name
  	case self.restriction
  		when 0 then "Carga"
  		when 1 then "Cliente"
  		when 2 then "Seguradora"
      when 3 then "Transportadora"
  		else "Nao Informado"
  	end
  end

	def self.driver_loking?(driver_id)
    DriverRestriction.locking.where(driver_id: driver_id).present?
  end

	def self.unlock(driver_id)
    DriverRestriction.where(id: driver_id.id).update_all(status: 1)
  end
end
