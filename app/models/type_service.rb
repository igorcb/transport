class TypeService < ActiveRecord::Base
	validates :descricao, presence: true, length: { maximum: 100 } 
	validates :tipo, presence:true

  #scope :red, -> { where(color: 'red') }
  scope :mudanca, -> { where(tipo: 0) }
  scope :logistica, -> { where(tipo: 1) }

  has_one :billing

  module Tipo
  	MUDANCA = 0
   	LOGISTICA = 1
  end

  def tipo_nome
    case self.tipo
      when 0 then "Mudanca"
      when 1 then "Logistica"
    else "Nao Definido"
    end
  end 

  
end
