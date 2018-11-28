class Pallet < ActiveRecord::Base
  validates :client_id, presence: true
  validates :data_informada, presence: true
  validates :qtde_informada, presence: true, numericality: { greater_than: 0 }
  validates :qtde, presence: true, numericality: { greater_than: 0 }, if: :data_agendamento?

  belongs_to :carrier, required: false
  belongs_to :client, required: false
  belongs_to :billing_client, class_name: "Client", foreign_key: 'billing_client_id', required: false

  has_one :ordem_service

  before_create :set_status

  has_many :nfe_keys, class_name: "NfeKey", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :nfe_keys, allow_destroy: true, :reject_if => :all_blank

  default_scope { order(id: :desc) }
  scope :open, -> { where(status: 0) }
  scope :complete, -> { where(status: 3) }
  scope :state_all, -> { all.joins(:client).select("clients.estado as estado, sum(qtde_informada) as qtde").group("clients.estado").having("sum(qtde_informada) > 0") }
  scope :state_open,  -> { open.joins(:client).select("clients.estado as estado, sum(qtde_informada) as qtde").group("clients.estado").having("sum(qtde_informada) > 0") }
  scope :state_complete, -> { complete.joins(:client).select("clients.estado as estado, sum(qtde) as qtde").group("clients.estado").having("sum(qtde) > 0") }

  after_save :set_qtde

  module TipoStatus
    ABERTO    = 0
    AGENDADO  = 1
    OS_CRIADA = 2
    CONCLUIDO = 3
  end

  module TypeService
    PALLET = 22
    VALOR_COBRADO_PALLETE = 9
  end

  def set_qtde
    volume = self.nfe_keys.sum(:volume)
    ActiveRecord::Base.transaction do
      Pallet.where(id: self.id).update_all(qtde: volume)
    end
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

  def create_os(options)
    ActiveRecord::Base.transaction do
      os = OrdemService.create!(tipo: OrdemService::TipoOS::LOGISTICA,
                               carrier_id: options[:carrier_id],
                                driver_id: options[:driver_id],
                               source_client_id: self.client_id,
                               target_client_id: self.client_id,
                               data: self.data_agendamento,
                               placa: options[:placa],
                               estado: options[:estado],
                               cidade: options[:cidade],
                               pallet_id: options[:pallet_id]
                               )
      qtde = self.qtde.present? ? self.qtde : self.qtde_informada
      valor = qtde.to_f * TypeService::VALOR_COBRADO_PALLETE
      OrdemServiceTypeService.create!(ordem_service_id: os.id,
                                       type_service_id: TypeService::PALLET,
                                                  qtde: qtde,
                                                 valor: valor
                                      )
      os.ordem_service_logistics.create( driver_id: options[:driver_id],
                                delivery_driver_id: options[:driver_id],
                                             placa: options[:placa],
                                       qtde_volume: qtde,
                                              peso: 0.00,
                                       qtde_palets: qtde
                                      )
      self.nfe_keys.each do |nfe|
        os.nfe_keys.create!(nfe: nfe.nfe,
                          chave: nfe.chave,
                           qtde: nfe.qtde,
                         volume: nfe.volume,
                           peso: nfe.peso
                          )
        ControlPallet.create!(client_id: self.billing_client_id,
                                 data: Date.today,
                                  qte: nfe.volume,
                                 tipo: ControlPallet::CreditoDebito::ENTRADA,
                                  nfe: nfe.nfe,
                         nfe_original: nfe.chave,
                            historico: "Entrada de Pallets No: #{self.id}",
                            carrier_id: self.carrier_id #carrier_id: 3 nao identificado
                          )
      end
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
