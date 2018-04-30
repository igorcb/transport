class ClientTablePrice < ActiveRecord::Base
  belongs_to :client
  belongs_to :type_service
  belongs_to :stretch_route

  scope :stretch_of_client, -> { ClientTablePrice.joins(stretch_route: [ :stretch_source, :stretch_target ]).order("stretches.destino") }

  module TypeCalc
    #Tipo de Calculo valor em cima da nota ou em cima do valor de servico
    #pegando da tabela ordem_service_type_service
    VALOR_NOTA =  0
    VALOR_SERVICO = 1
  end

  module TypeValuePercent
		VALOR =  0
		PERCENTUAL = 1
  end

  module CollectionDeliveryIncidence
		NAO_ADICIONA = 0
		ADICIONA_GERAL = 1
		ADICIONA_INDIVIDUAL = 2
  end

  module AddIcmsValueFete
  	OBEDECE_CLIENTE = 0
  	SIM = 1 
  	NAO = 2
  end

  module AddIcmsValueMinimum
  	OBEDECE_PREFERENCIA = 0
  	SIM = 1 
  	NAO = 2
  end

  module UseAliquotConsumerLast
  	ALIQUITA_TABELA_PADRAO = 1
  	ALIQUOTA_INTERNA_UF_DESTINO = 2
  end

  module ValidityStatus
  	LIBERADO = 0
  	BLOQUEADO = 1
  	VENCIDO = 2
  end

  def type_calc_name
    case self.type_calc
      when 0 then "Valor Nota"
      when 1 then "Valor Servico"
    end
  end

  def value_and_percent_name(type)
  	case type
  		when 0 then "Valor"
  		when 1 then "Percentual"
  	end
  end

  def freight_type_gris_name
 		value_and_percent_name(self.freight_type_gris)
  end

  def freight_type_trt_name
 		value_and_percent_name(self.freight_type_trt)
  end

  def collection_delivery_incidence_name
  	case self.collection_delivery_incidence
  		when 0 then "Não Adiciona"
  		when 1 then "Adiciona Geral"
  		when 2 then "Adiciona Individual"
  	end
  end

  def collection_delivery_add_icms_value_frete_name
  	case self.collection_delivery_ad_icms_value_frete
  		when 0 then "Obedece Cliente"
  		when 1 then "Sim"
  		when 2 then "Não"
  	end
  end

  def collection_delivery_add_icms_value_minimum_name
  	case self.collection_delivery_ad_value_minimum
  		when 0 then "Obedece Preferencia"
  		when 1 then "Sim"
  		when 2 then "Não"
  	end
  end

  def use_aliquot_consumer_last_name
  	case self.use_aliquot_consumer_last
  		when 0 then "Alíquito da Tabela (Padrão)"
  		when 1 then "Alíquota interna UF destino (quando for maior)"
		end
  end

  def validity_status_name
  	case self.validity_status
  		when 0 then "Liberado"
  		when 1 then "Bloqueado"
  		when 2 then "Vencido"
  	end
  end

  
end
