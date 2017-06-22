module BoardingsHelper
  def select_title_ocurrence
    ([["ALTERAÇÃO AGENDAMENTO", 0], 
    	["AVARIA NO RECEBIMENTO EM NOSSO CD", 1],
    	["AVARIA E FALTA NO RECEBIMENTO EM NOSSO CD", 2],
    	["CLIENTE RECUSOU A MERCADORIA", 3],
    	["CLIENTE RECUSOU A NOTA ", 4],
    	["DIVERGÊNCIA NA NOTAS FISCAL", 5],
      ["FALTA DE PEDIDO", 6],
    	["FALTA NO RECEBIMENTO EM NOSSO CD", 7],
    	["SEM PREVISÃO DE DESCARGA", 8]
     ])
  end

end