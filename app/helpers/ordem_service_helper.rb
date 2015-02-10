module OrdemServiceHelper
 
  def select_status_os
    ([["ABERTO", 0],["FECHADO", 1], ["FATURADO", 2], ["NAO FATURAR", 3], ["PAGO***", 99]])
  end

  def year_now
  	Time.now.strftime('%Y').to_i - 1
  end

  def tamanho_letra(qtde_nfe)
    case qtde_nfe
	    when 1 then tamanho = 200
	    when 2 then tamanho = 150
	    when 3 then tamanho = 100
	    else
	    	tamanho = 50
    end
    tamanho
  end
end
