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
    	["SEM PREVISÃO DE DESCARGA", 8],
      ["FALTA E SOBRA NO RECEBIMENTO EM NOSSO CD", 9],
      ["SOBRA NO RECEBIMENTO EM NOSSO CD", 10],
      ["PAGAMENTO DE DESCARGA ACIMA DO VALOR BASE", 11]
     ])
  end

  def select_status_boarding
    ([["Aberto", 0],
      ["Embarcado", 1],
      ["Entregue", 2]
     ])
  end

  def select_local_embarque
    ([["Fortaleza/CE", 1],
      ["Juazeiro do Norte/CE", 2],
      ["Simões Filho/BA", 3]
     ])
  end

  def verify_checkin_exist?(driver_cpf)
    Checkin.the_day.input.where(driver_cpf: driver_cpf).first.operation_id.present?
  end

end

      # when 0 then "Aberto"
      # when 1 then "Embarcado"
      # when 2 then "Entregue"
