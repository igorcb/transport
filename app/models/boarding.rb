class Boarding < ActiveRecord::Base
  validates :carrier_id, presence: true
  validates :driver_id, presence: true
  validates :status, presence: true
    
  belongs_to :carrier
  belongs_to :driver
  
  has_one :account_payable
  has_many :account_payables

  has_one :ordem_services
  has_many :boarding_items
  #accepts_nested_attributes_for :boarding_items, allow_destroy: true, :reject_if => :all_blank
  has_many :boarding_vehicles
  accepts_nested_attributes_for :boarding_vehicles, allow_destroy: true, :reject_if => :all_blank

  has_many :cte_keys, class_name: "CteKey", foreign_key: "cte_id", :as => :cte, dependent: :destroy
  accepts_nested_attributes_for :cte_keys, allow_destroy: true, :reject_if => :all_blank

  has_one :cancellation, class_name: "Cancellation", foreign_key: "cancellation_id"
  has_many :cancellations, class_name: "Cancellation", foreign_key: "cancellation_id", :as => :cancellation, dependent: :destroy
  accepts_nested_attributes_for :cancellations, allow_destroy: true, :reject_if => :all_blank


  before_destroy :erase_boarding_items

  module TipoStatus
  	ABERTO = 0
  	EMBARCADO = 1
  	ENTREGUE = 2
    CANCELADO = 3
  end

  def status_name
    case status
      when 0 then "Aberto"
      when 1 then "Embarcado"
      when 2 then "Entregue"
      when 3 then "Cancelado"
      else "Não Informado"
    end
  end

  def feed_cancellations
    Cancellation.where("cancellation_type = ? and cancellation_id = ?", "Boarding", self.id)
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
      OrdemService.where(id: hash_ids).update_all(status: OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
    end
    boarding
  end  

  def check_status_ordem_service?
    positivo = true
    self.boarding_items.order(:delivery_number).each do |item|
      #puts "Status: #{item.ordem_service.status} - #{item.ordem_service.status == OrdemService::TipoStatus::EMBARCADO}"
      positivo = item.ordem_service.status == OrdemService::TipoStatus::EMBARCADO 
      return false if positivo == false
    end
    positivo
  end  

  def check_status_ordem_service_entregue?
    positivo = true
    self.boarding_items.order(:delivery_number).each do |item|
      #puts "Status: #{item.ordem_service.status} - #{item.ordem_service.status == OrdemService::TipoStatus::EMBARCADO}"
      positivo = item.ordem_service.status == OrdemService::TipoStatus::ENTREGA_EFETUADA
      return false if positivo == false
    end
    positivo
  end  

  def close(ordem_service_id)
    ActiveRecord::Base.transaction do
      OrdemService.where(id: ordem_service_id).update_all(status: OrdemService::TipoStatus::EMBARCADO)
      Boarding.where(id: self.id).update_all(status: Boarding::TipoStatus::EMBARCADO) if self.check_status_ordem_service?
    end
  end

  def self.cancel(boarding_id)
    hash_ids = get_ordem_services_ids
    ActiveRecord::Base.transaction do
      #  OBS: quando cancelar o embarque, verificar a possibilidade de retirar a associacao da os no embarque
      OrdemService.where(id: hash_ids).update_all(status: OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
      Boarding.where(id: self.id).update_all(status: Boarding::TipoStatus::CANCELADO)
    end
  end

  def peso_bruto
    boarding_items.joins(:ordem_service).sum("ordem_services.peso")
  end

  def volume_total
    boarding_items.joins(:ordem_service).sum("ordem_services.qtde_volume")
  end

  def valor_total
    #valor_ordem_service
    soma = 0
    puts ">>>>>>>>>>>>>>>>>>> Valor Total: #{0.00}"
    self.boarding_items.each do |item| 
    puts ">>>>>>>>>>>>>>>>>>> OS: #{0.00}"
      soma += item.ordem_service.valor_ordem_service
    end
    soma
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

  def ordem_services_ids
    get_ordem_services_ids
  end

  def get_cities
    cities = []
    self.boarding_items.each do |item|
      cities << item.ordem_service.client.cidade
    end
    cities
  end

  private
  
    def get_ordem_services_ids
      hash_ids = []
      boarding = Boarding.find(self.id)
      boarding.boarding_items.each do |item|
        hash_ids << item.ordem_service_id
      end
      hash_ids
    end

end

