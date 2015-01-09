class Pallet < ActiveRecord::Base
  validates :client_id, presence: true
  validates :data_informada, presence: true
  validates :qtde_informada, presence: true, numericality: { greater_than: 0 }
  validates :qtde, presence: true, numericality: { greater_than: 0 }, if: :data_agendamento?
  belongs_to :client
  has_one :ordem_service
  before_create :set_status

  scope :open, -> { where(status: 0) }
  scope :complete, -> { where(status: 3) }
  scope :state_all, -> { all.joins(:client).select("clients.estado as estado, sum(qtde_informada) as qtde").group("clients.estado").having("sum(qtde_informada) > 0") }
  scope :state_open,  -> { open.joins(:client).select("clients.estado as estado, sum(qtde_informada) as qtde").group("clients.estado").having("sum(qtde_informada) > 0") }
  scope :state_complete, -> { complete.joins(:client).select("clients.estado as estado, sum(qtde) as qtde").group("clients.estado").having("sum(qtde) > 0") }


  module TipoStatus
    ABERTO    = 0
    AGENDADO  = 1
    OS_CRIADA = 2
    CONCLUIDO = 3
  end

  def set_status
  	self.status = 0
  end

  def status_name
    case self.status
	    when 0 then "Aberto"
	    when 1 then "Agendado"
	    when 2 then "OS Criada"
      when 3 then "Concluido"
    end
  end

  def create_os(*args)

    ActiveRecord::Base.transaction do
      os = OrdemService.create!(tipo: OrdemService::TipoOS::PALETE,
                               carrier_id: args[0],
                               driver_id: args[1],
                               client_id: self.client_id,
                               data: self.data_agendamento,
                               placa: args[2],
                               estado: args[3],
                               cidade: args[4],
                               pallet_id: args[5]
                               )
      valor = self.qtde * 9
      OrdemServiceTypeService.create!(ordem_service_id: os.id, 
                                      type_service_id: 22, 
                                      qtde: qtde,
                                      valor: valor
                                      )
      self.status = 2
      self.save!      
    end
  end

  def self.entrada
    type_service = 22
    OrdemService.includes(:ordem_service_type_service).where("ordem_services.status = ? and ordem_service_type_services.type_service_id = ?", 1, type_service).references(:ordem_service_type_service).sum("ordem_service_type_services.qtde")
  end

  def self.saida
    type_service = 23
    OrdemService.includes(:ordem_service_type_service).where("ordem_services.status = ? and ordem_service_type_services.type_service_id = ?", 1, type_service).references(:ordem_service_type_service).sum("ordem_service_type_services.qtde")
  end

end

