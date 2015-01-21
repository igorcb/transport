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
  belongs_to :client
  belongs_to :carrier
  belongs_to :pallet
  has_one :account_payable

  has_many :nfe_keys, class_name: "NfeKey", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :nfe_keys, allow_destroy: true, :reject_if => :all_blank

  has_many :ordem_service_type_service, dependent: :destroy
  accepts_nested_attributes_for :ordem_service_type_service, allow_destroy: true, :reject_if => :all_blank

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  has_many :account_banks, class_name: "AccountBank", foreign_key: "account_id", :as => :contact, dependent: :destroy
  accepts_nested_attributes_for :account_banks, allow_destroy: true

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
      Pallet.update(ordem_service.pallet, status: Pallet::TipoStatus::CONCLUIDO, qtde: qtde, data_fechamento: data)
      OrdemService.update(ordem_service, status: TipoStatus::FECHADO)
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

  private
    def can_destroy?
      if self.account_payable.present?
        errors.add(:base, "You can not delete record with relationship") 
        return false
      end
    end


end
