class OrdemService < ActiveRecord::Base
  IS_NUMBER = /\A[+-]?\d+\Z/  #/\D/
  resourcify

  validates :tipo, presence: true
  validates :target_client_id, presence: true
  validates :source_client_id, presence: true
  validates :estado, presence: true, length: { maximum: 2 } 
  validates :cidade, presence: true, length: { in: 3..100 }
  validates :carrier_id, presence: true, if: Proc.new { |o| o.tipo == TipoOS::AEREO }
  
#  validate :validate_danfe
  
  belongs_to :client, class_name: "Client", foreign_key: 'target_client_id'
  belongs_to :source_client, class_name: "Client", foreign_key: 'source_client_id'
  belongs_to :billing_client, class_name: "Client", foreign_key: 'billing_client_id'
  belongs_to :driver
  belongs_to :carrier
  belongs_to :pallet
  belongs_to :billing

  has_one :account_payable
  has_many :account_payables
  has_many :type_service, through: :ordem_service_type_service

  has_many :account_receivables

  has_many :nfe_keys, class_name: "NfeKey", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :nfe_keys, allow_destroy: true, :reject_if => :all_blank

  has_many :cte_keys, class_name: "CteKey", foreign_key: "cte_id", :as => :cte, dependent: :destroy
  accepts_nested_attributes_for :cte_keys, allow_destroy: true, :reject_if => :all_blank

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
  
  has_one :ordem_service_logistic
  has_many :ordem_service_logistics
  accepts_nested_attributes_for :ordem_service_logistics, allow_destroy: true, :reject_if => :all_blank

  has_one :ordem_service_air
  has_many :ordem_service_airs
  accepts_nested_attributes_for :ordem_service_airs, allow_destroy: true, :reject_if => :all_blank

  #scope :is_not_billed, -> { joins(:ordem_service_type_services).where(status: [0,1]).order('ordem_services.data desc') }
  scope :is_not_billed, -> { joins(:driver, :ordem_service_type_service, :type_service).where(status: [0,1]) }
  scope :group_by, -> { is_not_billed.select("ordem_services.placa as placa, drivers.nome as motorista,
                                              type_services.descricao as tipo_servico,
                                              sum(ordem_service_type_services.valor) as valor,
                                              sum(ordem_service_type_services.valor_pago) as valor_pago") 
                                      .group("ordem_services.placa, drivers.nome, type_services.descricao")
                                      .order("drivers.nome, ordem_services.placa")                                       
                      }
  
  before_save :set_values
  after_save :generate_billing 

  before_destroy :can_destroy?

  module TipoStatus
    ABERTO = 0
    FECHADO = 1
    FATURADO = 2
  end

  module TipoOS
    LOGISTICA = 1
    MUDANCA = 3
    AEREO = 4
  end

  def validate_danfe
    if !self.cte.blank?
      self.errors.add("Danfe CT-e", "can't be blank") if self.danfe_cte.blank?
      self.errors.add("Danfe CT-e", "is not a number") if self.danfe_cte.to_s !~ IS_NUMBER
    end
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
    ['data', 'data_entrega_servico', 'estado', 'cidade', 'senha_sefaz', "billing_id", "status" ]
  end

  def valor_ordem_service
    self.ordem_service_type_service.sum(:valor)
  end

  def valor_os(type_service)
    self.ordem_service_type_service.where(type_service_id: type_service).sum(:valor)
  end

  def valor_volume 
    valor = 0.00
    valor = self.ordem_service_logistic.qtde_volume * self.client.valor_volume if !self.ordem_service_logistic.qtde_volume.nil? && !self.client.valor_volume.nil?
    return valor  
  end
  
  def valor_peso
    valor = 0.00
    valor = self.ordem_service_logistic.peso * self.client.valor_peso if !self.ordem_service_logistic.peso.nil? && !self.client.valor_peso.nil?
    return valor  
  end 

  def valor_1500
    valor = 0.00
    valor = self.ordem_service_logistic.peso * 0.13 if !self.ordem_service_logistic.peso.nil?
    return valor
  end

  def self.valor_pgto_descarca_vol(client, os_volume)
    valor = 0.00
    valor_por_volume = 0.00
    valor_por_volume = client.valor_volume if client.present?
    valor = valor_por_volume.to_f * os_volume.to_f
    return valor
  end

  def self.valor_pgto_descarca_peso(client, os_peso)
    valor = 0.00
    valor_por_peso = 0.00
    valor_por_peso = client.valor_peso.to_f if client.present?
    valor = valor_por_peso.to_f * os_peso.to_f
    return valor
  end

  def self.valor_recebimento_descarca_vol(client, os_volume)
    valor = 0.00
    valor_por_volume = 0.00
    valor_por_volume = client.valor_volume.to_f if client.present?
    valor = valor_por_volume.to_f * os_volume.to_f
    valor_1500 = valor + ((valor * 30) / 100) #aplicar 30% do valor que foi cobrado a descarga por volume ou por peso 
    return valor_1500.to_f
  end

  def self.valor_recebimento_descarca_peso(client, os_peso)
    valor = 0.00
    valor_por_peso = 0.00
    valor_por_peso = client.valor_peso.to_f if client.present?
    valor = valor_por_peso.to_f * os_peso.to_f
    valor_1500 = valor + ((valor * 30) / 100) #aplicar 30% do valor que foi cobrado a descarga por volume ou por peso
    return valor_1500.to_f
  end

  def self.valor_recebimento_distribuicao(client, os_peso)
    valor = 0.00
    valor_por_peso = 0.00
    valor_por_peso = client.valor_peso_1500.to_f if client.present?
    valor = valor_por_peso.to_f * os_peso.to_f
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

  def generate_billing
    # Fazer algumas validacoes
    # se o cliente não tiver vencimento definido
    # centro de custo de acordo com o tipo de servico
    # se já tiver criado o faturamento, o que tem que fazer ?
      # se tiver varios serviços de 1 OS vai ser lancado varios contas a receber ?
      # se o usuario colocar os serviços aos poucos, pode excluir o contas a receber e gerar novamente ?
    # como vai ficar o status da OS, tinha Aberto, Fechado e Faturado, agora mudou o fluxo, já que é
      # faturado assim que cria a OS
    
    if self.billing_client.present?
      ActiveRecord::Base.transaction do
        self.account_receivables.destroy_all
        # Centro de Custo Galopao = 54
        case self.tipo
          when TipoOS::LOGISTICA then cost_center = CostCenter.find(58)
          when TipoOS::MUDANCA then cost_center = CostCenter.find(56)
          when TipoOS::AEREO then cost_center = CostCenter.find(57)
        end

        sub_cost_center = cost_center.sub_cost_centers.first
        historic = Historic.find(106) #Nao Definido
        valor = valor_ordem_service
        vencimento = get_due_client(self.created_at, self.billing_client)
        AccountReceivable.create!(client_id: self.billing_client_id,
                                  cost_center_id: cost_center.id,
                                  sub_cost_center_id: sub_cost_center.id,
                                  historic_id: historic.id,
                                  documento: self.id,
                                  valor: valor,
                                  data_vencimento: vencimento,
                                  ordem_service_id: self.id,
                                  observacao: "FATURA GERADA AUTOMÁTICA NA CRIAÇÃO DA O.S.")

      end
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

  def billing_to_client #para efeito de test no console
    get_due_client(self.created_at, self.billing_client)
  end

  private
    def can_destroy?
      if self.account_payable.present?
        errors.add(:base, "You can not delete record with relationship") 
        return false
      end
    end

    def get_due_client(date_os, client)
      vencimento = 0
      dia_os = date_os.day
      n = 0
      until n > 30 do
        if dia_os <= n
          vencimento = n+client.vencimento_para
          break
        end        
        n += client.faturar_cada
      end
      data = Time.now + 15.days
      data_vencimento = vencimento > 32 ? Date.new(data.year, data.month, client.vencimento_para) : Date.new(data.year, data.month, vencimento)
      data_vencimento
    end

end
