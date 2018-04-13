module ClientRepresentativesHelper
	
  def select_value_percent
    ([["Valor", 0], ["Percentual", 1]])
  end	

  def select_incidence
    ([["Não Adiciona", 0], ["Adiciona Geral", 1], ["Adiciona Individual", 2]])
  end	

  def select_use_aliquot
    ([["Alíquito da Tabela (Padrão)", 0], ["Alíquota interna UF destino (quando for maior)", 1]])
  end	

  def select_status_validity
    ([["Liberado", 0], ["Bloqueado", 1], ["Vencido", 2]])
  end	

  def select_add_icms_value_frete
    ([["Obedece Cliente", 0], ["Sim", 1], ["Não", 2]])
  end

  def select_add_icms_value_minimum
    ([["Obedece Preferência", 0], ["Sim", 1], ["Não", 2]])
  end
  
end
