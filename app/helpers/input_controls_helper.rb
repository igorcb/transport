module InputControlsHelper

  def select_status_input_control
    ([["Aberto", 0],["Recebido", 1], ["Fechado", 2], ["Faturado", 3], ["Dig.Finalizada",4]])
  end

  def select_equipamento
    ([["NOTA_FISCAL", 0],["PALETE", 1], ["CINTA", 2], ["CHAPATEX", 3]])
  end

  def select_team #ver final do arquivo
    ([["IMBATIVEIS", 1],["UNIDOS VENCEREMOS", 2], ["DIARISTA", 3]])
  end

  def select_dock 
    ([["1", 1],["2", 2], ["3", 3], ["4", 4], ["5", 5]])
  end

  def select_hangar
    ([["1", 1],["2", 2]])
  end

  def link_to_ordem_service(number)
		nfe_key = NfeKey.where(nfe_type: 'OrdemService', nfe: number)
		if nfe_key.present?
      link_to number, nfe_key.first.ordem_service
		else
			number
		end
  end

  def get_chave(id)
    nfe_xml = NfeXml.where(id: id)
    if nfe_xml.first.chave.present?
      nfe_xml.first.chave
    else
      nfe_xml.first.asset_file_name
    end
  end

  def calculation_discharge(value)
    calc = value * (InputControl::VALUE_DISCHARGE / 1000)
    number_to_currency(calc, precision: 2, unit: "R$ ", separator: ",", delimiter: ".")
  end

end

  # Fazer testes com esses helper
  #options_for_select([ "VISA", "MasterCard", "Discover" ], ["VISA", "Discover"])
  #options_for_select([ "Denmark", ["USA", {class: 'bold'}], "Sweden" ], ["USA", "Sweden"])
  #options_for_select([["Dollar", "$", {class: "bold"}], ["Kroner", "DKK", {onclick: "alert('HI');"}]])
  #options_for_select(["Free", "Basic", "Advanced", "Super Platinum"], disabled: "Super Platinum")
  #options_for_select(["Free", "Basic", "Advanced", "Super Platinum"], disabled: ["Advanced", "Super Platinum"])
  #options_for_select(["Free", "Basic", "Advanced", "Super Platinum"], selected: "Free", disabled: "Super Platinum")
