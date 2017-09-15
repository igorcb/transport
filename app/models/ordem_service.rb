#encoding: utf-8
class OrdemService < ActiveRecord::Base
  IS_NUMBER = /\A[+-]?\d+\Z/  #/\D/
  resourcify

  validates :tipo, presence: true
  validates :target_client_id, presence: true
  validates :source_client_id, presence: true
  validates :estado, presence: true, length: { maximum: 2 } 
  validates :cidade, presence: true, length: { in: 3..100 }
  validates :carrier_id, presence: true, if: Proc.new { |o| o.tipo == TipoOS::AEREO }
  
  validates_associated :ordem_service_type_service  
#  validate :validate_danfe
  
  belongs_to :client, class_name: "Client", foreign_key: 'target_client_id'
  belongs_to :source_client, class_name: "Client", foreign_key: 'source_client_id'
  belongs_to :billing_client, class_name: "Client", foreign_key: 'billing_client_id'
  belongs_to :driver
  belongs_to :carrier
  belongs_to :pallet
  belongs_to :billing
  belongs_to :input_control
  belongs_to :direct_charge
  
  has_one :boarding_item
  has_one :boarding, through: :boarding_item

  has_one :account_payable
  has_many :account_payables
  has_many :type_service, through: :ordem_service_type_service

  has_many :account_receivables

  has_many :nfe_keys, class_name: "NfeKey", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :nfe_keys, allow_destroy: true, :reject_if => :all_blank

  has_many :cte_keys, class_name: "CteKey", foreign_key: "cte_id", :as => :cte, dependent: :destroy
  accepts_nested_attributes_for :cte_keys, allow_destroy: true, :reject_if => :all_blank

  has_many :nfs_keys, class_name: "NfsKey", foreign_key: "nfs_id", :as => :nfs, dependent: :destroy
  accepts_nested_attributes_for :nfs_keys, allow_destroy: true, :reject_if => :all_blank

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
  
  has_one :ordem_service_change
  has_many :ordem_service_changes
  accepts_nested_attributes_for :ordem_service_changes, allow_destroy: true, :reject_if => :all_blank

  has_one :cancellation, class_name: "Cancellation", foreign_key: "cancellation_id"
  has_many :cancellations, class_name: "Cancellation", foreign_key: "cancellation_id", :as => :cancellation, dependent: :destroy
  accepts_nested_attributes_for :cancellations, allow_destroy: true, :reject_if => :all_blank

  has_many :item_ordem_services

  has_many :inventories

  #scope :is_not_billed, -> { joins(:ordem_service_type_services).where(status: [0,1]).order('ordem_services.data desc') }
  scope :status_open, -> { where(status: [TipoStatus::ABERTO, TipoStatus::AGUARDANDO_EMBARQUE]).order("id desc") }
  scope :is_not_billed, -> { joins(:driver, :ordem_service_type_service, :type_service).where(status: [0,1]) }
  scope :group_by, -> { is_not_billed.select("ordem_services.placa as placa, drivers.nome as motorista,
                                              type_services.descricao as tipo_servico,
                                              sum(ordem_service_type_services.valor) as valor,
                                              sum(ordem_service_type_services.valor_pago) as valor_pago") 
                                      .group("ordem_services.placa, drivers.nome, type_services.descricao")
                                      .order("drivers.nome, ordem_services.placa")                                       
                      }
  
  before_save :set_values, :validates_type_service
  after_save :set_peso_and_volume #:generate_billing 

  before_destroy :can_destroy?

  RECEIVABLE_COST_CENTER = 58  #LOGISTICA
  RECEIVABLE_SUB_COST_CENTER = 185 # OUTROS
  RECEIVABLE_COST_CENTER_THREE = 175 # OUTROS FATURAMENTO
  RECEIVABLE_PAYMENT_METHOD = 15 # TRANSFERENCIA BANCARIA

  module TipoStatus
    ABERTO = 0
    ENTREGA_EFETUADA = 1
    FECHADO = 2
    FATURADO = 3
    NAO_FATURAR = 4
    PAGA = 5
    SOLICITACAO_CANCELAMENTO = 6
    CANCELADA = 7
    AGUARDANDO_EMBARQUE = 8
    EMBARCADO = 9
    ARMAZENADO = 10
    PAGO_SEMFATURA = 99
  end
  #sequencia do status => [Aberto, Embarcando, Embarcado, Entrega Efetuada, Fechado, Faturado]

  module TipoOS
    LOGISTICA = 1
    MUDANCA = 3
    AEREO = 4
  end

  module AlertLeadTime
    ALERT    = 0 # se diferenca entre data der zero ou negativo está atrasado
    ALTO     = 1 # se diferenca entre data der um (1) ou está estado de alerta
    MEDIO    = 2 # se diferenca entre data der um (2) ou está estado de alerta medio
    BAIXO    = 3 # se diferenca entre data der um (3) ou está estado de alerta baixo
    NORMAL    = 4 # se diferenca entre data der um (3) ou está dentro do prazo
  end

  def set_peso_and_volume
    peso = self.nfe_keys.sum(:peso)
    volume = self.nfe_keys.sum(:volume)
    ActiveRecord::Base.transaction do
      puts "peso: #{peso} and volume: #{volume}"
      OrdemService.where(id: self.id).update_all(peso: peso, qtde_volume: volume)
      OrdemServiceLogistic.where(ordem_service_id: self.id).update_all(peso: peso, qtde_volume: volume)
    end
  end

  def validates_type_service
#    puts ">>>>>>>>>>>>>>.. Validates"
#    self.errors.add("Type Services", "can't be blank") if self.ordem_service_type_service.blank?
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
      when 1  then "Entregue"
      when 2  then "Fechado"
      when 3  then "Faturado"
      when 4  then "Nao Faturar"
      when 5  then "Pago"
      when 6  then "Canc. Solicitado"
      when 7  then "Cancelada"
      when 8  then "Ag. Emb."
      when 9  then "Embarcado"
      when 99 then "Pago***"
    else "Nao Definido"
    end
  end 

  def alert
    #(self.date_otif - Date.today).round
    days = self.date_otif.blank? ? AlertLeadTime::ALERT : (self.date_otif - Date.today).round
    days = 0 if days < 0 # se a data for negativa setar como zero
    days = 4 if days > 4 # se a data for maior que 4 setar como está no prazo
    case days
      when 0 then AlertLeadTime::ALERT
      when 1 then AlertLeadTime::ALTO
      when 2 then AlertLeadTime::MEDIO
      when 3 then AlertLeadTime::BAIXO
      when 4 then AlertLeadTime::NORMAL
    end
  end

  def alert_name
    #(self.date_otif - Date.today).round
    days = self.date_otif.blank? ? AlertLeadTime::ALERT : (self.date_otif - Date.today).round
    days = 0 if days < 0 # se a data for negativa setar como zero
    days = 4 if days > 4 # se a data for maior que 4 setar como está no prazo
    case days
      when 0 then "ALERT"
      when 1 then "ALTO"
      when 2 then "MEDIO"
      when 3 then "BAIXO"
      when 4 then "NORMAL"
    end
  end

  def tipo_os_name
    case self.tipo
      when 1 then "Logistica"
      when 2 then "Palete"
      when 3 then "Mudanca"
      when 4 then "Aereo"
    else "Nao Definido"
    end
  end 


  def self.locate(query)
    where("con_email ilike ?", "%#{query}%" )
  end  

  def self.ransackable_attributes(auth_object = nil)
    ['data', 'data_entrega_servico', 'estado', 'cidade', 'senha_sefaz', "billing_id", "status", "date_entry", 'date_shipping' ]
    #[:data, :data_entrega_servico, :estado, :cidade, :senha_sefaz, :billing_id, :status, :date_entry, :date_shipping ]
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
    valor_1500 = self.client.valor_peso_1500.nil? ? 0.00 : self.client.valor_peso_1500
    valor = self.ordem_service_logistic.peso * valor_1500 if !self.ordem_service_logistic.peso.nil?
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

  def valor_nota_fiscal
    self.item_ordem_services.sum(:valor)
  end

  def qtde
    self.ordem_service_type_service.sum(:qtde)
  end

  def qtde_palets
    self.ordem_service_logistic.qtde_palets
  end

  def qtde_cte
    self.cte_keys.count
  end

  def qtde_nfe
    self.nfe_keys.count
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

  def self.get_hash_ids(ids)
    hash_ids = []
    ids.each do |i|
      hash_ids << i[0].to_i
    end
    hash_ids
  end

  def self.invoice(ids, type_service, value)
    valor_total = 0
    hash_ids = []
    ids.each do |i|
      hash_ids << i[0].to_i
      valor_total += i[1].to_f
    end

    #if OrdemService.check_client_billing?(hash_ids)
    #  OrdemService.errors.add("Client Billing", "Customer invoices are not the same")
    #end

    # Efetuar Faturamento
    data = Time.now.strftime('%Y-%m-%d')
    os = OrdemService.find(hash_ids[0])
    venc = os.billing_to_client

    ActiveRecord::Base.transaction do
      billing = Billing.create!(data: data, valor: valor_total, data_vencimento: venc ,type_service_id: type_service, status: Billing::TipoStatus::ABERTO , obs: hash_ids.to_s)
      OrdemService.where(id: hash_ids).update_all(status: TipoStatus::FATURADO, billing_id: billing.id)
      AccountReceivable.where(ordem_service_id: hash_ids).update_all(billing_id: billing.id, data_vencimento: venc)
    end
  end

  def self.check_client_billing?(ids)
    # verifica se o cliente da fatura é o mesmo para todas as os
    positivo = true
    clients = OrdemService.where(id: ids)
    client = clients.first
    puts ">>>>>>>>>>>> first: #{client.billing_client_id}"
    clients.order(:id).each do |os|
      puts ">>>>>>>>>>>>. #{client.billing_client_id} - #{os.billing_client_id} - #{client.billing_client_id == os.billing_client_id}"
      positivo = client.billing_client_id == os.billing_client_id
      return false if positivo == false
    end
    positivo
  end

  def all_input_controls_closed
    positivo = true
    input_control = InputControl.find(self.input_control_id)
    input_control.ordem_services.each do |os|
      positivo = ((os.status == OrdemService::TipoStatus::FECHADO) or (os.status == OrdemService::TipoStatus::FATURADO))
      return false if positivo == false      
    end
    positivo
  end

  def close_ordem_service
    puts "Fechando a Ordem de Servico Model"
    case self.tipo
      when TipoOS::LOGISTICA then close_os_logistic # validacoes para fechamento
      when TipoOS::MUDANCA then close_os_change # validacoes para fechamento
      when TipoOS::AEREO then close_os_air # validacoes para fechamento
    end

    puts "Ordem de Servico fechada Model"
    if self.errors.present?
      puts "Errors: #{self.errors.messages}"
    else
      puts "Atualizando o Status para FECHADO e GERANDO o recebimento MODEL"
      ActiveRecord::Base.transaction do
        data_fechamento = Time.zone.now.strftime('%Y-%m-%d')
        OrdemService.update(self.id, data_fechamento: data_fechamento, status: OrdemService::TipoStatus::FECHADO)
        unless self.input_control_id.nil?
          InputControl.update(self.input_control_id, date_closing: data_fechamento, status: InputControl::TypeStatus::CLOSED) if all_input_controls_closed
        end
        OrdemService.generate_billing(self.id)
        puts "Gerou o recebimento"
        return true
      end
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

  def self.information_delivery(os_id)
    ordem_service = OrdemService.find(os_id)
    boarding = ordem_service.boarding_item.boarding if ordem_service.boarding_item.present?
    ActiveRecord::Base.transaction do
      OrdemService.where(id: os_id).update_all(status: OrdemService::TipoStatus::ENTREGA_EFETUADA)
      if ordem_service.boarding_item.present?
        Boarding.where(id: boarding.id).update_all(status: Boarding::TipoStatus::ENTREGUE) if boarding.check_status_ordem_service_entregue?
      end
      puts ">>>>>>>>>>>>>> information_delivery: pode enviar email?: #{ordem_service.input_control.present?}"
      OrdemServiceMailer.notification_delivery(ordem_service).deliver! if ordem_service.input_control.present?
    end
  end

  def self.cancel(user, options )
    ActiveRecord::Base.transaction do
      ordem_service = OrdemService.find(options[:ordem_service_id])
      ordem_service.status = TipoStatus::SOLICITACAO_CANCELAMENTO
      ordem_service.save!
      cancel = Cancellation.create!(solicitation_user_id: user,
                                     observacao: options[:observacao],
                                cancellation_id: options[:ordem_service_id],
                              cancellation_type: "OrdemService"
                         )
      cancel.send_notification_solicitation_cancellation
    end
  end

  def self.generate_billing(os_id)
    # Fazer algumas validacoes
    # se o cliente não tiver vencimento definido
    # centro de custo de acordo com o tipo de servico
    # se já tiver criado o faturamento, o que tem que fazer ?
      # se tiver varios serviços de 1 OS vai ser lancado varios contas a receber ?
      # se o usuario colocar os serviços aos poucos, pode excluir o contas a receber e gerar novamente ?
    # como vai ficar o status da OS, tinha Aberto, Fechado e Faturado, agora mudou o fluxo, já que é
      # faturado assim que cria a OS

    os = OrdemService.find(os_id)

    if os.billing_client.present?
      ActiveRecord::Base.transaction do
        #os.account_receivables.destroy_all #Não precisa mais apagar pois a conta só é criada quando fechar a OS
        # Centro de Custo Galpao = 54 isso é apenas um informativo
        case os.tipo
          when TipoOS::LOGISTICA then 
            cost_center = CostCenter.find(58)
            valor = os.valor_ordem_service
          when TipoOS::MUDANCA then cost_center = CostCenter.find(56)
            #definir com o Paulo de onde vem o valor da Ordem de Serviço
              #soma dos itens
              #do preenchimento do valor do servico = ordem_service_change.valor_total
            valor = os.valor_ordem_service
          when TipoOS::AEREO then 
            cost_center = CostCenter.find(57)
            valor = os.ordem_service_air.valor_total
        end
        sub_cost_center = cost_center.sub_cost_centers.first
        historic = Historic.find(106) #Nao Definido
        valor_das_parcelas = valor / os.billing_client.qtde_parcela
        ajuste = (valor - (valor_das_parcelas * os.billing_client.qtde_parcela)).round(2)
        vencimento = os.billing_to_client
        data_vencimento = nil
        os.billing_client.qtde_parcela.times do |time|
          valor = time == 0? (valor_das_parcelas + ajuste).round(2) : valor_das_parcelas.round(2)
          data_vencimento = time == 0? vencimento : (data_vencimento + os.billing_client.vencimento_para.days)
          AccountReceivable.create!(client_id: os.billing_client_id,
                                  cost_center_id: RECEIVABLE_COST_CENTER,
                                  sub_cost_center_id: RECEIVABLE_SUB_COST_CENTER,
                                  sub_cost_center_three_id: RECEIVABLE_COST_CENTER_THREE,
                                  historic_id: historic.id,
                                  payment_method_id: RECEIVABLE_PAYMENT_METHOD,
                                  documento: os.id,
                                  valor: valor,
                                  data_vencimento: data_vencimento,
                                  ordem_service_id: os.id,
                                  observacao: "FATURA GERADA AUTOMÁTICA NA CRIAÇÃO DA O.S.")
        end
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

  def feed_cancellations
    Cancellation.where("cancellation_type = ? and cancellation_id = ?", "OrdemService", self.id)
  end

  def cidade_estado
    self.cidade + '/' + self.estado
  end

  def billing_to_client #para efeito de test no console
    #get_due_client(self.created_at, self.billing_client)
    get_due_client(Date.current, self.billing_client)
  end

  def get_number_cte
    ctes = []
    self.cte_keys.each do |c|
      ctes << c.cte.to_i
    end
    ctes
  end

  def get_number_nfe
    nfes = []
    self.nfe_keys.each do |n|
      nfes << n.nfe
    end
    nfes
  end

  def get_number_nfse
    nfs = []
    self.nfs_keys.each do |n|
      nfs << n.nfs
    end
    nfs
  end

  def get_type_service
    services = []
    self.ordem_service_type_service.each do |n|
      services << n.type_service.descricao
    end
    services
  end

  def cliente_nome
    self.client.nome
  end

  def motorista_nome
    self.ordem_service_logistic.driver.nome
  end


  private
    def can_destroy?
      if self.account_payable.present?
        errors.add(:base, "You can not delete record with relationship") 
        return false
      end
    end

    def get_due_client(date_os, client)
      #vencimento ficou pegando da quantidade de dias para faturamento de 
      #acordo com o que está no cadastro

      #calculo par fatuar a cada x dias
      # vencimento = 0
      # dia_os = date_os.day
      # n = 0
      # until n > 30 do
      #   if dia_os <= n
      #     vencimento = n+client.vencimento_para
      #     break
      #   end        
      #   n += client.faturar_cada
      # end
      # data = Time.now + 15.days
      # data_vencimento = vencimento > 32 ? Date.new(data.year, data.month, client.vencimento_para) : Date.new(data.year, data.month, client.vencimento_para)
      # data_vencimento      
      #fim do calculo para faturar a cada x dias
      #client.faturar_cada = vencimento para x dias a partir da criação da os
      data_vencimento = date_os + client.faturar_cada.days
      data_vencimento.to_s
    end

    def has_address?
      self.ordem_service_change.source_endereco.present?
    end

    def close_os_logistic
      # self.cte_keys.each do |cte|
      #   #puts ">>>>>>>>>>>>. Validando CTE: #{cte.cte} is image: #{cte.is_image?}"
      #   self.errors.add("CTe-Keys", "#{cte.cte} is not image present") if !cte.asset.present?
      #   self.errors.add("CTe-Keys", "#{cte.cte} is not image Valid") if !cte.is_image?
      #   self.errors.add("CTe-Keys", "#{cte.cte} is not CT-e Valid") if !cte.tesseract_context?
      # end
      # self.nfe_keys.each do |nfe|
      #   #puts ">>>>>>>>>>>>. Validando NF-e: #{nfr.nfr} is image: #{nfe.is_image?}"
      #   self.errors.add("NFe-Keys", "#{nfe.nfe} is not image present") if !nfe.asset.present?
      #   self.errors.add("NFe-Keys", "#{nfe.nfe} is not image Valid") if !nfe.is_image?
      #   self.errors.add("NFe-Keys", "#{nfe.nfe} is not NF-e Valid") if !nfe.tesseract_context?
      # end
      puts ">>>>>>>>>>>> close_os_logistic Model <<<<<<<<<<<<<< "
      true
    end


    def close_os_change
      #fazer validacoes para fechamento
    end

    def close_os_air
      #fazer validacoes para fechamento
    end

end
