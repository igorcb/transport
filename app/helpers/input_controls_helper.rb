module InputControlsHelper

  def select_equipamento
    ([["NOTA_FISCAL", 0],["PALETE", 1], ["CINTA", 2], ["CHAPATEX", 3]])
  end

  def link_to_ordem_service(number)
		nfe_key = NfeKey.where(nfe: number)
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

end

  # def alert_color(ordem_service, alert)
  #   case alert
  #     when 0 then link_to "Alert", ordem_service, {:target => "_blank"}.merge(class: "btn btn-danger btn-xs")
  #     when 1 then link_to "Alto" , ordem_service, {:target => "_blank"}.merge(class: "btn btn-warning btn-xs")
  #     when 2 then link_to "Medio", ordem_service, {:target => "_blank"}.merge(class: "btn btn-yellow btn-xs")
  #     when 3 then link_to "Baixo", ordem_service, {:target => "_blank"}.merge(class: "btn btn-green btn-xs")
  #     when 4 then link_to "Normal", ordem_service, {:target => "_blank"}.merge(class: "btn btn-default btn-xs")
  #   end
    
    
  # end

