module TableFreightsHelper

  def select_type_charge_freight
  	([["Carga Geral", 0], ["Carga Neo Granel", 1], ["Carga Frigorificada", 2], ["Carga Perigosa", 3]])
  end

end
