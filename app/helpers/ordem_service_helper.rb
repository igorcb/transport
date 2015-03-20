module OrdemServiceHelper
 
  def select_status_os
    ([["ABERTO", 0],["FECHADO", 1], ["FATURADO", 2], ["NAO FATURAR", 3], ["PAGO***", 99]])
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
    #["PALETE", 3]
    ([["LOGISTICA", 1], ["MUDANCA", 2], ["AEREO", 4]])
  end

  def select_tipo_frete
    ([["CIF", 1], ["FOB", 2]])
  end
end
