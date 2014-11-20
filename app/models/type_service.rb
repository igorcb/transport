class TypeService < ActiveRecord::Base
	validates :descricao, presence: true, length: { maximum: 100 } 
	validates :tipo, presence:true

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
