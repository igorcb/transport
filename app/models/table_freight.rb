class TableFreight < ActiveRecord::Base
  validates :type_charge, presence: true
  validates :km_from, presence: true, :numericality => { :only_integer => true }
  validates :km_from, presence: true, :numericality => { :only_integer => true }
  validates :price, presence: true, numericality: { greater_than: 0 }

  module TypeCharge
		CARGA_GERAL = 0
		CARGA_GRANEL = 1
		CARGA_NEOGRANEL = 2
		CARGA_FRIGORIFICADA = 3
		CARGA_PERIGOSA = 4
  end

  def type_charge_name
    case self.type_charge
      when 0 then "Carga Geral"
      when 1 then "Carga Granel"
      when 2 then "Carga Neo Granel"
      when 3 then "Carga Frigorificada"
      when 4 then "Carga Perigosa"
    else "Nao Definido"
    end
  end
end
