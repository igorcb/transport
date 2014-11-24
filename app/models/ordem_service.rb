class OrdemService < ActiveRecord::Base
  
  validates :driver_id, presence: true
  validates :client_id, presence: true
  #validates :data, presence: true
  validates :placa, presence: true, length: { maximum: 10 }
  validates :estado, presence: true, length: { maximum: 2 } 
  validates :cidade, presence: true, length: { in: 3..100 }
  validates :cte, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }, uniqueness: true
  validates :danfe_cte, presence: true, length: { is: 44 }, numericality: { only_integer: true }
  
  belongs_to :driver
  belongs_to :client

  has_many :nfe_keys, class_name: "NfeKey", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :nfe_keys, allow_destroy: true, :reject_if => :all_blank

  has_many :ordem_service_type_service, dependent: :destroy
  accepts_nested_attributes_for :ordem_service_type_service, allow_destroy: true, :reject_if => :all_blank

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  before_save :set_values

  module TipoStatus
  	ABERTO = 0
  	FECHADO = 1
    FATURADO = 2
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
      when 2 then "Faturado"
    else "Nao Definido"
    end
  end 

  def valor_os
    self.ordem_service_type_service.sum(:valor)
  end

  def valor_os(type_service)
    self.ordem_service_type_service.where(type_service_id: type_service).sum(:valor)
  end

  def valor_volume 
    valor = 0.00
    valor = self.qtde_volume * self.client.valor_volume if !self.qtde_volume.nil? && !self.client.valor_volume.nil?
    return valor  
  end
  
  def valor_peso
    valor = 0.00
    valor = self.peso * self.client.valor_peso if !self.peso.nil? && !self.client.valor_peso.nil?
    return valor  
  end 

  def self.invoice(ids, type_service, value)
    valor_total = 0
    hash_ids = []
    ids.each do |i|
      hash_ids << i[0].to_i
      valor_total += i[1].to_f
    end
    # Efetuar Faturamento
    data = Time.now.strftime('%Y-%m-%d')
    ActiveRecord::Base.transaction do
      billing = Billing.create(data: data, valor: valor_total, type_service_id: type_service, status: Billing::TipoStatus::ABERTO , obs: hash_ids.to_s)
      OrdemService.where(id: hash_ids).update_all(status: TipoStatus::FATURADO, billing_id: billing.id)
    end
  end

end
