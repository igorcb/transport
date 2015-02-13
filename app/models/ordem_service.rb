class OrdemService < ActiveRecord::Base
  resourcify
  validates :driver_id, presence: true
  validates :client_id, presence: true
  #validates :data, presence: true
  validates :placa, presence: true, length: { maximum: 10 }
  validates :estado, presence: true, length: { maximum: 2 } 
  validates :cidade, presence: true, length: { in: 3..100 }
  validates :cte, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }, uniqueness: true, if: "tipo != 2"
  validates :danfe_cte, presence: true, length: { is: 44 }, numericality: { only_integer: true }, if: "tipo != 2"
  validates :carrier_id, presence: true, if: "tipo == 2"
  
  belongs_to :driver
  belongs_to :delivery_driver, class_name: "Driver", foreign_key: 'delivery_driver_id'
  belongs_to :client
  belongs_to :carrier
  belongs_to :pallet
  belongs_to :billing
  belongs_to :billing_client, class_name: "Client", foreign_key: 'billing_client_id'
  has_one :account_payable
  
  has_many :account_payables
  has_many :type_service, through: :ordem_service_type_service

  has_many :nfe_keys, class_name: "NfeKey", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :nfe_keys, allow_destroy: true, :reject_if => :all_blank

  has_many :ordem_service_type_service, dependent: :destroy
  accepts_nested_attributes_for :ordem_service_type_service, allow_destroy: true, :reject_if => :all_blank

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  has_many :account_banks, class_name: "AccountBank", foreign_key: "account_id", :as => :contact, dependent: :destroy
  accepts_nested_attributes_for :account_banks, allow_destroy: true

  has_many :comments, class_name: "Comment", foreign_key: "comment_id", :as => :comment, dependent: :destroy
  #has_many :commentaries, class_name: "Comment", foreign_key: "comment_id", :as => :comment, dependent: :destroy

  has_many :internal_comments, class_name: "InternalComment", foreign_key: "comment_id", :as => :comment, dependent: :destroy
  has_many :internal_commentaries, class_name: "InternalComment", foreign_key: "comment_id", :as => :comment, dependent: :destroy

  #scope :is_not_billed, -> { joins(:ordem_service_type_services).where(status: [0,1]).order('ordem_services.data desc') }
  scope :is_not_billed, -> { joins(:driver, :ordem_service_type_service, :type_service).where(status: [0,1]) }
  scope :group_by, -> { is_not_billed.select("ordem_services.placa as placa, drivers.nome as motorista,
                                              type_services.descricao as tipo_servico,
                                              sum(ordem_service_type_services.valor) as valor,
                                              sum(ordem_service_type_services.valor_pago) as valor_pago") 
                                      .group("ordem_services.placa, drivers.nome, type_services.descricao")
                                      .order("drivers.nome, ordem_services.placa")                                       
                      }
  before_save { |os| os.placa = placa.upcase }
  before_save :set_values

  before_destroy :can_destroy?

  module TipoStatus
    ABERTO = 0
    FECHADO = 1
    FATURADO = 2
  end

  module TipoOS
    MUDANCA = 0
    LOGISTICA = 1
    PALETE = 2
  end
  
  def set_values
    self.valor_receita  = 0
    self.valor_despesas = 0
    self.valor_liquido  = 0
  end

  def status_name
    case self.status
      when 0  then "Aberto"
      when 1  then "Fechado"
      when 2  then "Faturado"
      when 3  then "Nao Faturar"
      when 99 then "Pago***"
    else "Nao Definido"
    end
  end 

  def tipo_os_name
    case self.tipo
      when 0 then "Mudanca"
      when 1 then "Logistica"
      when 2 then "Palete"
    else "Nao Definido"
    end
  end 


  def self.locate(query)
    where("con_email ilike ?", "%#{query}%" )
  end  

  def self.ransackable_attributes(auth_object = nil)
    ['data', 'data_entrega_servico', 'placa', 'cte', 'estado', 'cidade', 'senha_sefaz', "billing_id", "status" ]
  end

  def valor_ordem_service
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

  def valor_1500
    valor = 0.00
    valor = self.peso * 0.13 if !self.peso.nil?
    return valor
  end

  def qtde
    self.ordem_service_type_service.sum(:qtde)
  end

  def danfes
    nfes = []
    self.nfe_keys.each do |n|
      nfes << n.nfe
    end
    nfes
  end

  def type_services
    services = []
    self.ordem_service_type_service.each do |t|
      services << "Serviço: #{t.type_service.descricao} || Valor: #{t.valor.to_f}"
    end
    services
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

  def self.close_os_agent(ordem_service)
    data = Time.now.strftime('%Y-%m-%d')
    qtde = OrdemServiceTypeService.where(ordem_service_id: ordem_service).sum(:qtde_recebida)
    ActiveRecord::Base.transaction do
      Pallet.update(ordem_service.pallet, status: Pallet::TipoStatus::CONCLUIDO, qtde: qtde, data_fechamento: data) if ordem_service.pallet.present?
      OrdemService.update(ordem_service, data_fechamento: data,  status: TipoStatus::FECHADO)
    end
  end

  def self.create_payables(ordem_service, item_ordem_service)
    data = Time.now.strftime('%Y-%m-%d')
    item = OrdemServiceTypeService.find(item_ordem_service)
    os = OrdemService.find(ordem_service)
    payment_method = PaymentMethod.find(6)
    historic = Historic.find(103)
    cost_center = CostCenter.find(49)
    sub_cost_center = SubCostCenter.find_by_type_service_id(item.type_service_id)
    
    # puts ">>>>>>>>>>>>> payment_method: #{payment_method.id}"
    # puts ">>>>>>>>>>>>> historic: #{historic.id}"
    # puts ">>>>>>>>>>>>> cost_center: #{cost_center.id}"
    # puts ">>>>>>>>>>>>> sub_cost_center: #{sub_cost_center.id}"
    # puts ">>>>>>>>>>>>> item: #{item.id}"
    # puts ">>>>>>>>>>>>> os: #{os.id}"

    ActiveRecord::Base.transaction do
      AccountPayable.create!(type_account: 3,
                            supplier_type: "Client", 
                              supplier_id: os.client_id,
                              historic_id: historic.id,
                        payment_method_id: payment_method.id,
                           cost_center_id: cost_center.id,
                       sub_cost_center_id: sub_cost_center.id,
                          data_vencimento: data,
                                documento: os.id,
                                    valor: item.valor_pago,
                               observacao: "REF: #{sub_cost_center.type_service.descricao}",
                         ordem_service_id: os.id,
            ordem_service_type_service_id: item.id
                            )
      item.status = OrdemServiceTypeService::TipoStatus::PENDENTE
      item.save!
   
    end
  end

  def feed
    Comment.where("comment_type = ? and comment_id = ?", "OrdemService", self.id)
  end

  def feed_internal_comments
    InternalComment.where("comment_type = ? and comment_id = ?", "OrdemService", self.id)
  end

  def cidade_estado
    self.cidade + '/' + self.estado
  end

  private
    def can_destroy?
      if self.account_payable.present?
        errors.add(:base, "You can not delete record with relationship") 
        return false
      end
    end


end
