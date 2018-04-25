module OrdemServiceHelper
 
  def select_status_os
    #([["ABERTO", 0],["FECHADO", 1], ["FATURADO", 2], ["NAO FATURAR", 3], ["PAGO***", 99]])
    ([["ABERTO", 0], ["ENTREGA_EFETUADA", 1], ["FECHADO", 2], ["FATURADO", 3], ["NAO_FATURAR", 4],
        ["PAGA", 5], ["SOLICITACAO_CANCELAMENTO", 6], ["CANCELADA", 7], ["AGUARDANDO_EMBARQUE", 8],
        ["EMBARCADO", 9], ["ARMAZENADO", 10], ["PAGO_SEMFATURA", 99]])
  end

  def year_now
  	Time.now.strftime('%Y').to_i - 1
  end

  def tamanho_letra(qtde_nfe)
    case qtde_nfe
	    when 1 then tamanho = 170
	    when 2 then tamanho =  65
	  else
	    	tamanho = 50
    end
    tamanho
  end

  def select_tipo_ordem_servico
    #["PALETE", 2]
    ([["LOGISTICA", 1], ["MUDANCA", 3], ["AEREO", 4]])
  end

  def select_tipo_frete
    ([["CIF", 1], ["FOB", 2]])
  end

  def alert_color(ordem_service, alert)
    case alert
      when 0 then link_to "Alert", ordem_service, {:target => "_blank"}.merge(class: "btn btn-danger btn-xs")
      when 1 then link_to "Alto" , ordem_service, {:target => "_blank"}.merge(class: "btn btn-warning btn-xs")
      when 2 then link_to "Medio", ordem_service, {:target => "_blank"}.merge(class: "btn btn-yellow btn-xs")
      when 3 then link_to "Baixo", ordem_service, {:target => "_blank"}.merge(class: "btn btn-green btn-xs")
      when 4 then link_to "Normal", ordem_service, {:target => "_blank"}.merge(class: "btn btn-default btn-xs")
    end
  end

  def select_status_login
    ([ ["CANCELADO", 0], 
       ["FATURADO", 1], 
       ["FECHADO", 2], 
       ["LIBERADO PAGAMENTO", 3], 
       ["PENDENTE", 4], 
       ["PENDENTE PDF", 5] 
       ["APROVADO", 6] 
       ["REPROVADO", 7] 
       ["PEND. XML", 8] 
    ])
  end

  def table_price_of_billing_client(client)
    ClientTablePrice.joins(:type_service).stretch_of_client.where(client_id: client)
                                      .select("client_table_prices.id as client_table_price_id", 
                                      "stretches.destino || '/' || stretch_targets_stretch_routes.destino || '/' || type_services.descricao as trecho")
  end



end
