class OrdemServiceTypeService < ActiveRecord::Base
  #include UpdateOrCreate
  #validates :ordem_service, presence: true
  validates :type_service, presence: true
  validates :valor, presence: true, numericality: { greater_than: 0 }, if: :value_service?

  belongs_to :ordem_service, required: false
  belongs_to :type_service, required: false
  belongs_to :client_table_price, required: false
  belongs_to :stretch_route, required: false
  has_one :account_payable
  has_one :ordem_service_table_price, dependent: :destroy

  scope :both, -> { joins(:type_service, :ordem_service).order('ordem_services.data desc') }
  scope :status_open, -> { joins(:type_service, :ordem_service).where(status: [0, 1]).order('ordem_services.data desc') }
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

  def value_service?
    self.client_table_price.type_calc == ClientTablePrice::TypeCalc::VALOR_SERVICO
  end

  def sum_total
    self.valor +
      calculate_margin_lucre +
      calculate_freight_weight +
      calculate_freight_volume +
      calculate_freight_value
  end

  def calc_minimum_total_freight
    value_total = 0.00
    s_total = sum_total
    value_total = (s_total >= self.client_table_price.minimum_total_freight) ? s_total : self.client_table_price.minimum_total_freight
  end

  def total_service
    value_total = 0.00
    if self.client_table_price.collection_delivery_ad_icms_value_frete == ClientTablePrice::AddIcmsValueFete::SIM
      value_total = calc_minimum_total_freight + calculate_icms + calculate_iss
    else
      value_total = calc_minimum_total_freight
    end
  end

  def calculate_margin_lucre
    perc_margem = 0.00
    #if self.client_table_price.present?
      perc_margem = self.client_table_price.margin_lucre if self.client_table_price.present?
      margin_lucre = (self.valor * perc_margem ) / 100.00
    #end
  end

  def calculate_iss
    iss = 0.00
    margin_lucre = value_service? ? calculate_margin_lucre : calc_minimum_total_freight
    iss = self.client_table_price.collection_delivery_iss if self.client_table_price.present?
    perc_iss = 1 - ( iss / 100)
    value_iss = ((self.valor.to_f + margin_lucre) / perc_iss) - (self.valor.to_f + margin_lucre)
  end

  def calculate_freight_weight
    value_total = 0.00
    self.client_table_price.freight_weight * self.ordem_service.peso #if self.client_table_price.present?
  end

  def calculate_freight_volume
    value_total = 0.00
    self.client_table_price.freight_volume * self.ordem_service.qtde_volume #if self.client_table_price.present?
  end

  def calculate_freight_value
    value_total = 0.00
    (self.client_table_price.freight_value * self.ordem_service.valor_nota_fiscal) / 100 #if self.client_table_price.present?
  end

  def calculate_icms
    icms = 0.00
    icms = self.client_table_price.collection_delivery_icms_taxpayer if self.client_table_price.present?
    valor_calc = calc_minimum_total_freight
    perc_icms = 1 - ( icms / 100)
    value_icms = ((valor_calc) / perc_icms) - (valor_calc)
    value_icms
  end

  def create_or_update_table_price
    #table_price = ClientTablePrice.where(id: self.client_table_price_id, client_id: self.ordem_service.billing_client_id, type_service_id: self.type_service_id).first
    table_price = ClientTablePrice.where(client_table_price_id: self.ordem_service.billing_client_id,
                                               type_service_id: self.type_service_id,
                                              stretch_route_id: self.stretch_route_id).first
    #puts ">>>>>>>>>>>>>>>>> TablePrice: #{table_price.present?}"
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
                                                           freight_volume_tax: table_price.freight_volume,
                                                         freight_volume_value: self.calculate_freight_volume,
                                                            freight_value_tax: table_price.freight_value,
                                                                freight_value: self.calculate_freight_value,
                                                             freight_icms_tax: table_price.collection_delivery_icms_taxpayer,
                                                           freight_icms_value: self.calculate_icms,
                                                                total_service: self.total_service)
  end

end
