class Boarding < ActiveRecord::Base
  validates :carrier_id, presence: true
  validates :driver_id, presence: true
  validates :status, presence: true
    
  belongs_to :carrier
  belongs_to :driver

  has_one :ordem_services
  has_many :boarding_items
  #accepts_nested_attributes_for :boarding_items, allow_destroy: true, :reject_if => :all_blank
  has_many :boarding_vehicles
  accepts_nested_attributes_for :boarding_vehicles, allow_destroy: true, :reject_if => :all_blank

  has_many :cte_keys, class_name: "CteKey", foreign_key: "cte_id", :as => :cte, dependent: :destroy
  accepts_nested_attributes_for :cte_keys, allow_destroy: true, :reject_if => :all_blank


  before_destroy :erase_boarding_items

  module TipoStatus
  	ABERTO = 0
  	FECHADO = 1
  	CANCELADO = 2
  end

  def erase_boarding_items
    ActiveRecord::Base.transaction do
      OrdemService.where(id: [self.boarding_items.ids]).update_all(status: OrdemService::TipoStatus::ABERTO)
      self.boarding_items.each do |item|
        item.destroy
      end
    end
  end

  def self.generate_shipping(ids)
    hash_ids = []
    ids.each do |i|
      hash_ids << i[0].to_i
    end

    driver = Driver.find(105) #Motorista Padrao - Motorista Não Identificado
    carrier = Carrier.find(3) #Agent Padrao - Agent Não Identificado
    boarding = nil
    ActiveRecord::Base.transaction do
      boarding = Boarding.create!(driver_id: driver.id, carrier_id: carrier.id, status: TipoStatus::ABERTO)
      hash_ids.each do |os|
      	boarding.boarding_items.create!(ordem_service_id: os, delivery_number: 1)
      end
      OrdemService.where(id: hash_ids).update_all(status: OrdemService::TipoStatus::EMBARCANDO)
    end
    boarding
  end  

  def peso_bruto
    boarding_items.joins(:ordem_service).sum("ordem_services.peso")
  end

  def volume_total
    boarding_items.joins(:ordem_service).sum("ordem_services.qtde_volume")
  end

  def qtde_palets
    soma = 0
    self.boarding_items.each do |item|
      soma += item.ordem_service.qtde_palets
    end
    soma
  end

  def qtde_cte
    soma = 0
    self.boarding_items.each do |item|
      soma += item.ordem_service.qtde_cte
    end
    soma
  end

  def qtde_nfe
    soma = 0
    self.boarding_items.each do |item|
      soma += item.ordem_service.qtde_nfe
    end
    soma
  end

  def qtde_entregas
    number = self.boarding_items.group('delivery_number').having('delivery_number > 0').count
    number.count
  end

end

