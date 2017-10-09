module VehiclesHelper
  def select_tipo
    ([["REBOQUE", 0],["TRACAO", 1]])
  end

  def select_tipo_veiculo
    # ([["STANDARD", 0],["LS", 1],["BAU", 2],["TRUK", 3],["TOCO", 4],["CARRETA", 5], 
    # 	["CAVALO MECÂNICO", 6], ["UTILITARIO", 7], ["VAN", 8], ["NAO APLICAVEL"] 
    # ])

    {
      'Leves' => [["Toco", 4], ["VLC", 2], ["3/4", 6], ["UTILITARIO", 7], ["VAN", 8]],
      'Médios' => [["Truck", 3], ["Bitruck", 9]],
      'Pesados' => [["Rodotrem", 10], ["Bitrem", 11], ["Carreta LS", 1], ["Carreta", 5]],
      'Nao Aplicavel' => [["Nao Aplicavel", 99]]
    }
  end

  def select_tipo_carroceria
    #([["ABERTA", 0],["FECHADA BAU", 1],["GRANELEIRA", 2],["PORTA CONTAINER", 3],["SIDER", 4],["NAO APLICAVEL", 5]])

    {
      'Fechada' => [["Baú", 1], ["Baú Frigorifico", 5], ["Sider", 4]],
      'Aberta' => [["Caçamba", 6], ["Grade Baixa", 7], ["Graneleiro", 2], ["Cavaqueira", 8], ["Prancha", 9]],
      'Especial' => [["Bug Porta Container", 3], ["Munk", 10], ["Silo", 11], ["Tanque", 12], ["Gaiola", 13], 
                     ["Cegonheiro", 14], ["Apenas Cavalo", 15]],
      'Nao Aplicavel' => [["Nao Aplicavel", 99]]
    }

  end

  def select_tipo_piso_assoalho
    ([["FERRO", 0],["MADEIRA", 1]])
  end

end
