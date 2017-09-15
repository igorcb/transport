module SchedulingsHelper
  def select_modal
    ([["CONTAINER 20", "CONTAINER 20"], ["CONTAINER 40", "CONTAINER 40"], ["CARRETA", "CARRETA"]])
  end	

  def select_status_scheduling
    ([["Não Recebido", 0], ["Recebido", 1], ["Cancelado", 2]])
  end	
end
