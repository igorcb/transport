module OrdemServiceHelper
 
  def select_status
    ([["ABERTO", 0],["FECHADO", 1]])
  end

  def year_now
  	Time.now.strftime('%Y').to_i - 1
  end

end