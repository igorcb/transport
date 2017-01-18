class Boarding < ActiveRecord::Base
  validates :carrier_id, presence: true
  validates :driver_id, presence: true
  validates :status, presence: true
    
  belongs_to :carrier
  belongs_to :driver

  has_one :ordem_services
  has_many :boarding_items, dependent: :destroy
  #has_many :boarding_items, class_name: "NfeKey", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :boarding_items, allow_destroy: true, :reject_if => :all_blank


  module TipoStatus
  	ABERTO = 0
  	FECHADO = 1
  	CANCELADO = 2
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
      boarding = Boarding.create!(driver_id: driver, carrier_id: carrier, status: TipoStatus::ABERTO)
      hash_ids.each do |os|
      	boarding.boarding_items.create!(ordem_service_id: os, delivery_number: 1)
      end
      OrdemService.where(id: hash_ids).update_all(status: OrdemService::TipoStatus::EMBARQUE)
    end
    boarding
  end  
end
