class ClientDischarge < ActiveRecord::Base
  belongs_to :client
  belongs_to :client_source, class_name: "Client", foreign_key: :client_source_id


  module TypeUnit
  	BOX = 0
  	BURDEN = 1
  	TAMBO = 2
  	BIG_BAG = 3
  end

  module TypeCharge
		PALLETIZED = 0
		SLAM = 1
		MIXED = 2
		ADJUSTED = 3
  end

  module TypeCalc
  	WEIGHT = 0
  	UNIT = 1
  	VALUE = 2
  end

  def type_unit_name
  	case self.type_unit
  		when TypeUnit::BOX then "Caixaria"
  		when TypeUnit::BURDEN then "Fardo"
  		when TypeUnit::TAMBO then "Tambor"
  		when TypeUnit::BIG_BAG then "Big Bag"
  	end
  end

  def type_charge_name
  	case self.type_charge
  		when TypeCharge::PALLETIZED then "Paletizada"
  		when TypeCharge::SLAM then "Batida"
  		when TypeCharge::MIXED then "Mista"
  		when TypeCharge::ADJUSTED then "Acertado"
  	end
  end

  def type_calc_name
  	case self.type_calc
  		when TypeCalc::WEIGHT then "Peso"
  		when TypeCalc::UNIT   then "Unidade"
  		when TypeCalc::VALUE  then "Valor"
  	end
  end

end
