module VehiclesHelper
  def select_tipo
    ([["REBOQUE", 0],["TRACAO", 1]])
  end

  def select_tipo_veiculo
    ([["STANDARD", 0],["LS", 1],["BAU", 2],["TRUK", 3],["TOCO", 4],["CARRETA", 5], 
    	["CAVALO MECÂNICO", 6], ["UTILITARIO", 7], ["VAN", 8], ["NAO APLICAVEL"] 
    ])
  end

  def select_tipo_carroceria
    ([["ABERTA", 0],["FECHADA BAU", 1],["GRANELEIRA", 2],["PORTA CONTAINER", 3],["SIDER", 4],["NAO APLICAVEL", 5]])
  end

end
