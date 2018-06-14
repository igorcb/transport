module ClientDischargesHelper
  def select_type_unit
    ([["Caixaria", 0], ["Fardo", 1], ["Tambor", 2], ["Big Bag", 3]])
  end	

  def select_type_charge
  	([["Paletizada", 0], ["Batida", 1], ["Mista", 2], ["Acertado", 3]])
  end

  def select_type_calc_charge
  	([["Peso", 0], ["Unidade", 1], ["Valor", 2]])
  end

  #def calc_value_discharge(params = {})
  def calc_value_discharge(params = {})
  	discharge = params[:discharge]
  	value = BigDecimal.new 0

  	if discharge.type_unit == ClientDischarge::TypeUnit::BOX &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::PALLETIZED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::WEIGHT
  		value_calc = discharge.calc_weight(params[:weight])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BOX &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::PALLETIZED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::UNIT
  		value_calc = discharge.calc_unit(params[:unit])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BOX &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::PALLETIZED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::VALUE
  		value_calc = discharge.price
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BURDEN &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::PALLETIZED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::WEIGHT
  		value_calc = discharge.calc_weight(params[:weight])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BURDEN &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::PALLETIZED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::UNIT
  		value_calc = discharge.calc_unit(params[:unit])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BURDEN &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::PALLETIZED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::VALUE
  		value_calc = discharge.price
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::TAMBO &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::PALLETIZED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::WEIGHT
  		value_calc = discharge.calc_weight(params[:weight])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::TAMBO &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::PALLETIZED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::UNIT
  		value_calc = discharge.calc_unit(params[:unit])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::TAMBO &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::PALLETIZED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::VALUE
  		value_calc = discharge.price
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BOX &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::SLAM &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::WEIGHT
  		value_calc = discharge.calc_weight(params[:weight])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BOX &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::SLAM &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::UNIT
  		value_calc = discharge.calc_volume(params[:volume])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BOX &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::SLAM &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::VALUE
  		value_calc = discharge.price
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BOX &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::MIXED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::WEIGHT
  		value_calc = discharge.calc_weight(params[:weight])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BOX &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::MIXED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::UNIT
  		value_calc = discharge.calc_unit(params[:unit])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BOX &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::MIXED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::VALUE
  		value_calc = discharge.price
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BURDEN &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::SLAM &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::WEIGHT
  		value_calc = discharge.calc_weight(params[:weight])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BURDEN &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::SLAM &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::UNIT
  		value_calc = discharge.calc_unit(params[:unit])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BURDEN &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::SLAM &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::VALUE
  		value_calc = discharge.price
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BURDEN &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::MIXED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::WEIGHT
  		value_calc = discharge.calc_weight(params[:weight])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BURDEN &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::MIXED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::UNIT
  		value_calc = discharge.calc_unit(params[:unit])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BURDEN &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::MIXED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::VALUE
  		value_calc = discharge.price
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::TAMBO &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::SLAM &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::WEIGHT
  		value_calc = discharge.calc_weight(params[:weight])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::TAMBO &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::SLAM &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::UNIT
  		value_calc = discharge.calc_unit(params[:unit])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::TAMBO &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::SLAM &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::VALUE
  		value_calc = discharge.price
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::TAMBO &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::MIXED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::WEIGHT
  		value_calc = discharge.calc_weight(params[:weight])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::TAMBO &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::MIXED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::UNIT
  		value_calc = discharge.calc_unit(params[:unit])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::TAMBO &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::MIXED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::VALUE
  		value_calc = discharge.price
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BIG_BAG &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::PALLETIZED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::WEIGHT
  		value_calc = discharge.calc_weight(params[:weight])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BIG_BAG &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::PALLETIZED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::UNIT
  		value_calc = discharge.calc_unit(params[:unit])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BIG_BAG &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::PALLETIZED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::VALUE
  		value_calc = discharge.price
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BIG_BAG &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::SLAM &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::WEIGHT
  		value_calc = discharge.calc_weight(params[:weight])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BIG_BAG &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::SLAM &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::UNIT
  		value_calc = discharge.calc_unit(params[:unit])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BIG_BAG &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::SLAM &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::VALUE
  		value_calc = discharge.price
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BIG_BAG &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::MIXED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::WEIGHT
  		value_calc = discharge.calc_weight(params[:weight])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BIG_BAG &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::MIXED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::UNIT
  		value_calc = discharge.calc_unit(params[:unit])
  		return value_calc
  	end

  	if discharge.type_unit == ClientDischarge::TypeUnit::BIG_BAG &&
  		 discharge.type_charge == ClientDischarge::TypeCharge::MIXED &&
  		 discharge.type_calc == ClientDischarge::TypeCalc::VALUE
  		value_calc = discharge.price
  		return value_calc
  	end

  end
  	

end
