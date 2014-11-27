class TypeService < ActiveRecord::Base
	validates :descricao, presence: true, length: { maximum: 100 } 
	validates :tipo, presence:true

  has_many :ordem_service_type_services

  scope :mudanca, -> { where(tipo: 0) }
  scope :only_logistica, -> { where(tipo: 1) }
  scope :logistica, -> { where(tipo: [1, 2] ) }
  scope :only_paletes, -> { where(tipo: 2) }

  has_one :billing

  module Tipo
  	MUDANCA = 0
   	LOGISTICA = 1
    PALETES = 2
  end

  def tipo_nome
    case self.tipo
      when 0 then "Mudanca"
      when 1 then "Logistica"
      when 2 then "Paletes"
    else "Nao Definido"
    end
  end 

  
end
