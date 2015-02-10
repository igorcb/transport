module OrdemServiceHelper
 
  def select_status_os
    ([["ABERTO", 0],["FECHADO", 1], ["FATURADO", 2], ["NAO FATURAR", 3], ["PAGO***", 99]])
  end

  def year_now
  	Time.now.strftime('%Y').to_i - 1
  end

end
