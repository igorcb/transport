module TableFreightsHelper

  def select_type_charge_freight
  	([["Carga Geral", 0], ["Carga Neo Granel", 1], ["Carga Frigorificada", 2], ["Carga Perigosa", 3]])
  end

  def select_eixos
		([["3", 3], ["4", 4], ["5", 5], ["6", 6], ["7", 7], ["8", 8]])
  end

  def select_seller_commission
  	([["Em cima do valor do frete", 0], ["Em cima do lucro", 1]])
  end

end
