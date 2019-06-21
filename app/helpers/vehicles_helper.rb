module VehiclesHelper
  def select_tipo
    ([["REBOQUE", 0],["TRACAO", 1],["TRACAO_BAU", 2]])
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

  def select_fechada
    array = []
    array.push(id: 1, name: 'Baú')
    array.push(id: 5, name: 'Baú Frigorifico')
    array.push(id: 4, name: 'Sider')
    array
  end

  def select_aberta
    array = []
    array.push(id: 6, name: 'Caçamba')
    array.push(id: 7, name: 'Grade Baixa')
    array.push(id: 2, name: 'Graneleiro')
    array.push(id: 8, name: 'Cavaqueira')
    array.push(id: 9, name: 'Prancha')
    array
  end

  def select_especial
    array = []
    array.push(id: 6, name: 'Bug Porta Container')
    array.push(id: 7, name: 'Munk')
    array.push(id: 2, name: 'Silo')
    array.push(id: 8, name: 'Tanque')
    array.push(id: 9, name: 'Gaiola')
    array.push(id: 9, name: 'Cegonheiro')
    array.push(id: 9, name: 'Apenas Cavalo')
    array
  end

end
