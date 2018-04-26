class OrdemServiceTypeService < ActiveRecord::Base
  #validates :ordem_service, presence: true
  validates :type_service, presence: true
  validates :valor, presence: true, numericality: { greater_than: 0 }

  belongs_to :ordem_service
  belongs_to :type_service
  belongs_to :client_table_price
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

  module StatusLogin
    CANCELADO = 0
    FATURADO  = 1
    FECHADO   = 2
    LIBERADO_PAGAMENTO = 3
    PENDENTE = 4
    PENDENTE_PDF =5
    APROVADO = 6 
    REPROVADO = 7 
    PEND_XML = 8
  end

  def status_name
    case self.status
      when 0  then "Aberto"
      when 1  then "Pendente"
      when 2  then "Pago"
    else "Nao Definido"
    end
  end 

  def status_login_name
    case self.status_login
      when 0  then "CANCELADO"
      when 1  then "FATURADO"
      when 2  then "FECHADO"
      when 3  then "LIBERADO_PAGAMENTO"
      when 4  then "PENDENTE"
      when 5  then "PENDENTE_PDF"
      when 6  then "APROVADO"
      when 7  then "REPROVADO"
      when 8  then "PEND. XML"
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
    if (self.valor + calculate_margin_lucre + calculate_iss) < self.client_table_price.minimum_total_freight
      self.client_table_price.minimum_total_freight
    else
      (self.valor + calculate_margin_lucre + calculate_iss)
    end
  end

  def calculate_margin_lucre
    perc_margem = 0.00
    perc_margem = self.client_table_price.margin_lucre if self.client_table_price.present?
    margin_lucre = (self.valor * perc_margem ) / 100.00
  end

  def calculate_iss
    margin_lucre = calculate_margin_lucre
    iss = 0.00
    iss = self.client_table_price.collection_delivery_iss if self.client_table_price.present?
    perc_iss = 1 - ( iss / 100)
    value_iss = ((self.valor + margin_lucre) / perc_iss) - (self.valor + margin_lucre) 
  end

  def calculate_freight_weight
    self.client_table_price.freight_weight * self.ordem_service.peso
  end

  # def calculate_minimum_total_freight
  #   self.client_table_price.freight_weight * self.ordem_service.peso
  # end

  def create_or_update_table_price
    table_price = ClientTablePrice.where(id: self.client_table_price_id, client_id: self.ordem_service.billing_client_id, type_service_id: self.type_service_id).first

    ordem_service_table_price = OrdemServiceTablePrice.where(ordem_service_id: self.ordem_service_id, 
                                                              type_service_id: self.type_service_id,
                                                        client_table_price_id: self.client_table_price_id,
                                                ordem_service_type_service_id: self.id)
                                                      .update_or_create(
                                                                      iss_tax: table_price.collection_delivery_iss,
                                                                    iss_value: self.calculate_iss,
                                                             margin_lucre_tax: table_price.margin_lucre,
                                                           margin_lucre_value: self.calculate_margin_lucre,
                                                           freight_weight_tax: table_price.freight_weight,
                                                         freight_weight_value: self.calculate_freight_weight,
                                                                total_service: self.total_service)
  end


end

