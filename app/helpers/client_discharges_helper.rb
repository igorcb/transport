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

end
