class OrdemServiceTypeService < ActiveRecord::Base
  #validates :ordem_service, presence: true
  validates :type_service, presence: true
  validates :valor, presence: true, numericality: { greater_than: 0 }

  belongs_to :ordem_service
  belongs_to :type_service
  has_one :account_payable
  has_one :ordem_service_table_price

  scope :both, -> { joins(:type_service, :ordem_service).order('ordem_services.data desc') }
  scope :open, -> { joins(:type_service, :ordem_service).where(status: [0, 1]).order('ordem_services.data desc') }
  scope :close, -> { joins(:type_service, :ordem_service).where(status: 2).order('ordem_services.data desc') }
#  scope :everyday, ->(date) { both.where("ordem_services.data = ?", date ) }

  after_save :create_or_update_table_price

  module TipoStatus
    ABERTO = 0
    PENDENTE = 1
    PAGO = 2
  end

  def status_name
    case self.status
      when 0  then "Aberto"
      when 1  then "Pendente"
      when 2  then "Pago"
    else "Nao Definido"
    end
  end 

  def opened?
    self.status == TipoStatus::ABERTO
  end

  # def self.locate(query)
  #   where("con_email ilike ?", "%#{query}%" )
  # end  

  def self.ransackable_attributes(auth_object = nil)
    ['status' ]
  end

  def self.send_report
    #puts ">>>>>>>>>>>>>>>>>>> model: vai enviar e-mail"
    #OrdemServiceTypeService.report_mailer.deliver_now
    #Cobranca.notificar_financeiro_f13(cobranca) 
  end

  def advance_money
    AdvanceMoney.where(number: self.advance_money_number).first
  end

  def total_service
    if self.ordem_service.client_table_price.present?
      self.valor + calculate_margin_lucre + calculate_iss
    end
  end

  def calculate_margin_lucre
    margin_lucre = (self.valor * self.ordem_service.client_table_price.margin_lucre) / 100.00
  end

  def calculate_iss
    margin_lucre = calculate_margin_lucre
    perc_iss = 1 - (self.ordem_service.client_table_price.collection_delivery_iss / 100)
    value_iss = ((self.valor + margin_lucre) / perc_iss) - (self.valor + margin_lucre) 
  end

  def create_or_update_table_price
    client_id = self.ordem_service.billing_client_id
    client_table_price = self.ordem_service.client_table_price_id
    table_price = ClientTablePrice.where(id: client_table_price, client_id: client_id, type_service_id: self.type_service_id).first
    ordem_service_table_price = OrdemServiceTablePrice.where(ordem_service_id: client_id, 
                                                              type_service_id: self.type_service_id,
                                                        client_table_price_id: table_price.id,
                                                ordem_service_type_service_id: self.id)
                                                      .update_or_create(
                                                                      iss_tax: table_price.collection_delivery_iss,
                                                                    iss_value: self.calculate_iss,
                                                             margin_lucre_tax: table_price.margin_lucre,
                                                           margin_lucre_value: self.calculate_margin_lucre,
                                                                total_service: self.total_service)
  end


end

