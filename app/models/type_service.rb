class TypeService < ActiveRecord::Base
	validates :descricao, presence: true, length: { maximum: 100 } 
	validates :tipo, presence:true

  has_many :ordem_service_type_services

  scope :mudanca, -> { where(tipo: 0) }
  scope :only_logistica, -> { where(tipo: 1) }
  scope :only_paletes, -> { where(tipo: 2) }
  scope :logistica, -> { where(tipo: [1,2] ) }

  has_one :billing

  has_many :ordem_service_type_services
  has_one :sub_cost_center
  #has_many :ordem_service, through: :ordem_service_type_services

  before_destroy :can_destroy?

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

  private
    def can_destroy?
      if self.ordem_service_type_services.present? 
        errors.add(:base, "You can not delete record with relationship") 
        return false
      end
    end  
 
end

