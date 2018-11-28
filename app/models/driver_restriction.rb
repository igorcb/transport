class DriverRestriction < ActiveRecord::Base
	validates :client_id, presence: true
	validates :restriction, presence: true

	belongs_to :driver, required: false
  belongs_to :client, required: false

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
end
