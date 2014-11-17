class OrdemService < ActiveRecord::Base
  
  validates :driver_id, presence: true
  validates :client_id, presence: true
  validates :data, presence: true
  validates :placa, presence: true, length: { maximum: 10 }
  validates :estado, presence: true, length: { maximum: 2 } 
  validates :cidade, presence: true, length: { in: 3..100 }
  validates :cte, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }
  validates :danfe_cte, presence: true, length: { is: 44 }, numericality: { only_integer: true }
  validates :nfe, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }
  validates :danfe_nfe, presence: true, length: { is: 44 }, numericality: { only_integer: true }

  belongs_to :driver
  belongs_to :client

  has_many :nfe_keys, class_name: "NfeKey", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :nfe_keys, allow_destroy: true, :reject_if => :all_blank

  has_many :ordem_service_type_service, dependent: :destroy
  accepts_nested_attributes_for :ordem_service_type_service, allow_destroy: true, :reject_if => :all_blank

  before_save :set_values

  module TipoStatus
  	ABERTO = 0
  	FECHADO = 1
  end
  
  def set_values
    self.valor_receita  = 0
    self.valor_despesas = 0
    self.valor_liquido  = 0
  end

  def status_name
    case self.status
      when 0 then "Aberto"
      when 1 then "Fechado"
    else "Nao Definido"
    end
  end  

end
