class InputControl < ActiveRecord::Base
  include ClientCreateOrUpdate

  validates :carrier_id, :driver_id, presence: true
	validates :place, :place_horse, :place_cart, :date_entry, :time_entry, presence: true

  belongs_to :carrier, required: false
  belongs_to :driver, required: false
  belongs_to :user, required: false
  belongs_to :user_received, class_name: "User", foreign_key: "received_user_id", required: false
  belongs_to :started_user, class_name: "User", foreign_key: "started_user_id", required: false
  belongs_to :billing_client, class_name: "Client", foreign_key: "billing_client_id", required: false
  belongs_to :scheduling, class_name: "Scheduling", foreign_key: "conteiner_id", required: false
  belongs_to :client_table_price, required: false
  belongs_to :strecht_route, required: false
  belongs_to :type_service, required: false

  has_many :nfe_xmls, class_name: "NfeXml", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :nfe_xmls, allow_destroy: true, :reject_if => :all_blank

  has_many :ordem_services
  has_many :item_input_controls
  has_many :item_nfes, class_name: "ItemInputControl", foreign_key: "nfe_id"

  has_one :account_receivable

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  has_one :cancellation, class_name: "Cancellation", foreign_key: "cancellation_id"
  has_many :cancellations, class_name: "Cancellation", foreign_key: "cancellation_id", :as => :cancellation, dependent: :destroy
  accepts_nested_attributes_for :cancellations, allow_destroy: true, :reject_if => :all_blank

  has_many :comments, class_name: "Comment", foreign_key: "comment_id", :as => :comment, dependent: :destroy

  has_many :breakdowns, as: :breakdown, dependent: :destroy
  #has_many :breakdowns, -> { order(:lastname => :asc) }, as: :breakdown, dependent: :destroy
  accepts_nested_attributes_for :breakdowns, allow_destroy: true, reject_if: :all_blank

  has_one :action_inspector
  has_many :action_inspectors
  accepts_nested_attributes_for :action_inspectors, allow_destroy: true, :reject_if => :all_blank

  has_many :conferences, class_name: "Conference", foreign_key: "conference_id", :as => :conference, dependent: :destroy

  #enum charge_type_delivery: { nao: 0, sim: 1 }

  scope :the_day, -> { includes(:driver).where(date_entry: Date.current).order("id desc") }
  scope :the_day_scheduled, -> { includes(:driver).where(date_scheduled: Date.current).order(date_scheduled: :desc, time_scheduled: :asc) }
  scope :opened, -> { includes(:driver).where(date_scheduled: Date.current, status: [TypeStatus::OPEN, TypeStatus::FINISH_TYPING ] ).order("id desc") }
  scope :received, -> { includes(:driver).where(date_scheduled: Date.current, status: TypeStatus::RECEIVED ).order("id desc") }
  scope :discharge, -> { includes(:driver).where(date_scheduled: Date.current, status: [TypeStatus::DISCHARGE, TypeStatus::CONFERENCE] ).order("id desc") }
  scope :pending, -> { includes(:driver).where("date_entry > ? and date_entry < ? and status = ?", (Date.current - 3.day), Date.current, TypeStatus::RECEIVED).order("id desc") }
  scope :not_discharge_weight, -> { where(charge_discharge: true) }
  scope :available_admin, -> { includes(:driver).where("date_entry > ?", (Date.current - 30.day)).where(status: [TypeStatus::FINISH_TYPING, TypeStatus::DISCHARGE, TypeStatus::CONFERENCE]).order("id desc") }
  scope :available_discharge, -> { includes(:driver).where(date_scheduled: Date.current, status: [TypeStatus::FINISH_TYPING, TypeStatus::DISCHARGE, TypeStatus::CONFERENCE, TypeStatus::RECEIVED]).order("id desc") }
  scope :available_supervisor, -> { includes(:driver).where(date_scheduled: Date.current, status: [TypeStatus::FINISH_TYPING, TypeStatus::DISCHARGE, TypeStatus::CONFERENCE, TypeStatus::RECEIVED]).order("id desc") }
  scope :available_operator, -> { includes(:driver).where(date_scheduled: Date.current).where.not(team: nil).order("id desc") }

  #before_save { |item| item.email = email.downcase }
  # RECEBIMENTO_DESCARGA_HISTORIC = 100
  # RECEBIMENTO_DESCARGA_PAYMENT_METHOD = 2
  # RECEBIMENTO_DESCARGA_COST_CENTER = 81
  # RECEBIMENTO_DESCARGA_SUB_COST_CENTER = 269
  # RECEBIMENTO_DESCARGA_SUB_COST_CENTER_THREE = 160

  VALUE_DISCHARGE = 0.93 #POR TONELADA

  ID_GROUP_QUIMICA_AMPARO_INT = 10
  ID_GROUP_QUIMICA_AMPARO_STR = '10'

  before_save do |item|
    item.place = place.upcase
    item.place_horse = place_horse.upcase
    item.place_cart = place_cart.upcase
    item.place_cart_2 = place_cart_2.upcase
  end

  before_create do |item|
    set_values
    item.date_scheduled = date_entry
    item.time_scheduled = time_entry
  end

  #after_save :processa_nfe_xmls

  # dia 01/10/2018 ajustar para 28 reais descarga por tonelada,
  # dia 15/07/2019 ajustar para 30 reais descarga por tonelada,
  # Verificar a possibilidade de mudar essa contante em variável
  # buscando da tabela de parametros do sistema
  VALOR_DA_TONELADA = 30

  module TipoCarga
    BATIDA = false
    PALETIZADA  = true
  end

  module TypeStatus
    OPEN   = 0
    RECEIVED = 1
    CLOSED  = 2
    BILLED = 3
    FINISH_TYPING = 4
    DISCHARGE = 5
    CONFERENCE = 6
  end #ordem do processo OPEN, FINISH TYPING, DISCHARGE, CONFERENCE, RECEIVED, CLOSE, BILLIED

  module TypeTeam
    IMBATIVEIS = 1
    UNIDOS_VENCEREMOS = 2
    DIARISTA = 3
  end

  def scheduling_search
    Scheduling.where(container: self.container)
  end

  def self.ransackable_attributes(auth_object = nil)
    ['id', 'carrier', 'driver_id','place','date_entry', 'date_receipt', 'date_scheduled', 'status', 'shipment', 'container']
  end

  def self.select_date_receipt
    InputControl.joins(:nfe_xmls).where(charge_discharge: true, :nfe_xmls => {equipamento: NfeXml::TipoEquipamento::NOTA_FISCAL, create_os: NfeXml::TipoOsCriada::SIM})
                .where.not(date_receipt: nil)
                .select(:date_receipt, "SUM(nfe_xmls.peso) as peso", "coalesce(SUM(nfe_xmls.peso_liquido),0) AS peso_liquido, AVG(nfe_xmls.peso) as media")
                .group(:date_receipt)
                .order(date_receipt: :desc)
                .collect {|input| [input.date_receipt, input.peso, input.peso_liquido, input.media]}

  end

  def self.select_date_receipt_total
      InputControl.joins(:nfe_xmls).where(charge_discharge: true, :nfe_xmls => {equipamento: NfeXml::TipoEquipamento::NOTA_FISCAL, create_os: NfeXml::TipoOsCriada::SIM})
                .where.not(date_receipt: nil)
                .select("SUM(nfe_xmls.peso) as peso", "coalesce(SUM(nfe_xmls.peso_liquido),0) AS peso_liquido, AVG(nfe_xmls.peso) as media")
                .collect {|input| [input.peso, input.peso_liquido, input.media]}
  end

  def status_received?
    puts ">>>>>>>>>>>>>>>> Status: #{self.status_name} : Result: #{self.status == TypeStatus::RECEIVED}"
    self.status == TypeStatus::RECEIVED
  end

  def status_open_and_finish_typing_and_discharge?
    self.status == TypeStatus::OPEN || self.status == TypeStatus::FINISH_TYPING || self.status == TypeStatus::DISCHARGE
  end

  def charge_discharge_status
    case self.charge_discharge
      when false then "Nao"
      when true then "Sim"
      else "Nao Informado"
    end
  end

  def palletized_status
    case self.palletized
      when false then "Nao"
      when true then "Sim"
      else "Nao Informado"
    end
  end

  def status_name
    case self.status
      when 0 then "Aberto"
      when 1 then "Recebido"
      when 2 then "Fechado"
      when 3 then "Faturado"
      when 4 then "Dig.Finalizada"
      when 5 then "Descarregando"
      when 6 then "Conferencia"
      else "Nao Informado"
    end
  end

  def team_name
    case self.team
      when 1 then "IMBATIVEIS"
      when 2 then "UNIDOS_VENCEREMOS"
      when 3 then "DIARISTA"
      else "Nao Informado"
    end
  end

  def set_values
    self.weight = 0.00
    self.volume = 0.00
    self.value_kg = valor_kg
    self.value_total = 0.00
    self.value_ton  = VALOR_DA_TONELADA
  end

  def set_peso_and_volume
    # peso = self.nfe_xmls.sum("COALESCE(peso,0)")
    # volume = self.nfe_xmls.sum("COALESCE(volume,0)")
    # valor_total = peso * valor_kg
    # ActiveRecord::Base.transaction do
    #   puts "peso: #{peso} and volume: #{volume} and Ton: #{valor_tonelada} and TonKG: #{valor_kg} and ValorTotal: #{valor_total} "
    #   InputControl.where(id: self.id).update_all(weight: peso, volume: volume, value_total: valor_total)
    # end
    InputControls::SetWeightAndVolumeService.new(self).call
  end

  def set_peso_and_volume_only_nfe_product
    # peso = self.nfe_xmls.sum("COALESCE(peso,0)")
    # volume = self.nfe_xmls.sum("COALESCE(volume,0)")
    # valor_total = peso * valor_kg
    # ActiveRecord::Base.transaction do
    #   puts "peso: #{peso} and volume: #{volume} and Ton: #{valor_tonelada} and TonKG: #{valor_kg} and ValorTotal: #{valor_total} "
    #   InputControl.where(id: self.id).update_all(weight: peso, volume: volume, value_total: valor_total)
    # end
    InputControls::SetWeightAndVolumeService.new(self).call
  end

  def valor_tonelada
  	VALOR_DA_TONELADA
  end

  def valor_kg
    valor = 0.00
  	valor = (VALOR_DA_TONELADA / 1000.00)
  	valor
  end

  def valor_total
    valor = 0.00
    valor = valor_kg * self.weight
    valor
  end

  def processa_nfe_xmls
    self.nfe_xmls.each do |nfe|
      NfeXml.processa_xml_input_control(nfe)
      set_peso_and_volume
    end
  end

  def self.check_client_billing?(ids)
    # verifica se o cliente da fatura é o mesmo para todas as nfe_xmls
    positivo = true
    clients = NfeXml.where(id: ids)
    client = clients.first
    clients.order(:id).each do |os|
      positivo = client.source_client_id == os.source_client_id
      return false if positivo == false
    end
    positivo
  end

  def self.check_client?(ids)
    # verifica se o cliente da fatura é o mesmo para todas as nfe_xmls
    positivo = true
    clients = NfeXml.where(id: ids)
    client = clients.first
    clients.order(:id).each do |os|
      positivo = client.target_client_id == os.target_client_id
      return false if positivo == false
    end
    positivo
  end

  def check_all_ordem_services_billing?
    positivo = true
    #input_control = InputControl.find(self.id)
    self.ordem_services.each do |os|
      positivo = (os.status == OrdemService::TipoStatus::FATURADO)
      return false if positivo == false
    end
    positivo
  end

  def check_nfe_xmls_have_qtde_pallets_total?
    positivo = true
    self.nfe_xmls.each do |nfe|
      positivo = nfe.qtde_pallet.blank? ? false : true
      return false if positivo == false
    end
    positivo
  end

  def self.update_input_control_billing(input_control)
    InputControl.where(id: input_control.id).update_all(status: TypeStatus::BILLED)
  end

  def self.client_not_credentials_sefaz?(client_ids)
    result = Client.where(id: [client_ids], client_credential_sefaz: false).present?
  end

  def self.start(input_control_id)
    # Fazer validacoes
    #InputControl.where(id: input_control_id).update_all(start_time_discharge: Time.current, status: InputControl::TypeStatus::DISCHARGE)
    input_control = InputControl.find(input_control_id)
    checkin = Checkin.the_day.input.where(driver_cpf: input_control.driver.cpf).first
    ActiveRecord::Base.transaction do
      Checkin.where(id: checkin.id).update_all(operation_id: input_control_id)
      Checkin.create!( driver_cpf: input_control.driver.cpf,
                      driver_name: input_control.driver.nome.upcase,
                   operation_type: :input_control,
                     operation_id: input_control_id,
                      place_horse: checkin.place_horse,
                     place_cart_1: checkin.place_cart_1,
                     place_cart_2: checkin.place_cart_2,
                             door: checkin.door,
                           status: :start)
      InputControl.where(id: input_control_id).update_all(start_time_discharge: Time.current, status: InputControl::TypeStatus::DISCHARGE)
    end
  end

  def received
    # so pode informar recebimento se a remessa estiver no status FINISH_TYPING
    # fazer checagem se necessario

    return_value = false
    begin
      checkin = Checkin.the_day.input.where(driver_cpf: self.driver.cpf).first
      ActiveRecord::Base.transaction do
        return_value = true
        self.update_attributes(date_receipt: Date.current, finish_time_discharge: Time.current, status: InputControl::TypeStatus::RECEIVED)
        nfe_input_control = self.nfe_xmls.first
        nfe_scheduling = NfeXml.where(nfe_type: "Scheduling", numero: nfe_input_control.numero).first
        Scheduling.where(id: nfe_scheduling.nfe_id).update_all(date_receipt_at: Time.current, status: Scheduling::TypeStatus::RECEIVED) if nfe_scheduling.present?
        Checkin.create!( driver_cpf: self.driver.cpf,
                        driver_name: self.driver.nome.upcase,
                     operation_type: :input_control,
                       operation_id: self.id,
                        place_horse: checkin.place_horse,
                       place_cart_1: checkin.place_cart_1,
                       place_cart_2: checkin.place_cart_2,
                               door: checkin.door,
                             status: :finish)
        return_value = true
      end
    rescue Exception => e
      self.update_attributes(date_receipt: nil, status: InputControl::TypeStatus::FINISH_TYPING)
      puts e.message
      self.errors[:base] << e.message
      return_value = false
      #raise ActiveRecord::Rollback
    end
  end

  def finish_typing
    return_value = false
    begin
      ActiveRecord::Base.transaction do
        #criar contas a receber
        if self.charge_discharge?
          set_peso_and_volume_only_nfe_product
          AccountReceivable.create!(
                                 type_account: AccountReceivable::TypeAccount::MOTORISTA,
                                  client_type: AccountReceivable::TypeAccountName::MOTORISTA,
                                    client_id: self.driver_id,
                             input_control_id: self.id,
                               cost_center_id: InputControl.recebimento_descarga_cost_center,
                           sub_cost_center_id: InputControl.recebimento_descarga_sub_cost_center,
                     sub_cost_center_three_id: InputControl.recebimento_descarga_sub_cost_center_three,
                            payment_method_id: PaymentMethod.payment_method_default,
                                  historic_id: InputControl.recebimento_descarga_historic,
                              data_vencimento: Date.today,
                                    documento: self.id,
                                        valor: self.value_total,
                                   observacao: "RECEBIMENTO DE DESCARGA REMESSA No: #{self.id}, NF-e: #{get_number_nfe_xmls}",
                                       status: AccountReceivable::TipoStatus::ABERTO
                                 )
        end
        #colocar remessa como digitação finalizada
        self.update_attributes(status: InputControl::TypeStatus::FINISH_TYPING)
        return_value = true
      end
    # rescue Exception => e
    #   return_value = false
    #   raise ActiveRecord::Rollback
    # end
    rescue Exception => e
      puts e.message
      self.errors[:base] << e.message
      return_value = false
      return false
    end
  end

  def self.create_stok_pallets(params = {})
    puts ">>>>>>>>>>>>  params: #{params.to_s}"
    input_control = InputControl.find(params[:id])
    nfe_xmls = input_control.nfe_xmls.pallets.not_create_os.where(id: params[:nfe])
    target_client = nfe_xmls.first.target_client
    source_client = nfe_xmls.first.source_client
    ActiveRecord::Base.transaction do
      nfe_xmls.each do |nfe|
        control_pallet = ControlPallet.create!(
                      client_id: source_client.id,
                     carrier_id: input_control.carrier.id,
                           data: input_control.date_receipt,
                            qte: nfe.volume,
                           tipo: ControlPallet::CreditoDebito::ENTRADA,
                            nfe: nfe.numero,
                   nfe_original: nfe.chave,
                           peso: nfe.peso,
                         volume: nfe.volume,
                         status: ControlPallet::TipoStatus::ABERTO,
         generate_ordem_service: false,
               input_control_id: input_control.id,
                      historico: "Entrada de Paletes pela Remessa de Entrada. No: #{input_control.id} "
                            )
        NfeXml.where(id: nfe.id).update_all(create_os: NfeXml::TipoOsCriada::SIM)
        ControlPalletMailer.notification_pallets(control_pallet).deliver!
      end

    end
  end

  def carrier_credentials?
    carrier_default = Carrier.where(cnpj: Company.first.cnpj).first
    return carrier_default.credentials.where(carrier_credential: self.carrier).present?
  end

  def self.create_ordem_service_input_controls(params = {})
    #byebug
    action_inspector_number = nil
    input_control = InputControl.find(params[:id])
    nfe_xmls = input_control.nfe_xmls.nfe.not_create_os.where(id: params[:nfe])
    total_weight = input_control.nfe_xmls.nfe.sum(:peso).to_f
    target_client = nfe_xmls.first.target_client
    source_client = nfe_xmls.first.source_client
    billing_client = input_control.billing_client

    value_weight_average = BigDecimal.new(0)

    if input_control.client_table_price.present?
      value_weight_average = input_control.client_table_price.minimum_total_freight / total_weight
    end
    #carrier = Carrier.find(3) #DEFAULT NÃO INFORMADO, ATUALIZAR NO EMBARQUE
    nfe_scheduling = NfeXml.where(nfe_type: "Scheduling", numero: nfe_xmls.first.numero).first

    data_scheduling = nil
    if nfe_scheduling.present?
      data_scheduling = nfe_scheduling.scheduling.date_scheduling_client.present? ? nfe_scheduling.scheduling.date_scheduling_client : nil
    end

    action_inspector_number = input_control.action_inspector.number if input_control.action_inspector.present?

    ActiveRecord::Base.transaction do
      #puts ">>>>>>>>>>>>>>>> Criar Ordem de Servico"
      ordem_service = OrdemService.create!( tipo: OrdemService::TipoOS::LOGISTICA,
                              ordem_service_type: 'type_input_control',
                                input_control_id: input_control.id,
                                target_client_id: target_client.id,
                                source_client_id: source_client.id,
                           #     billing_client_id: billing_client.id,
                           # client_table_price_id: billing_client.client_table_price_reset.id,
                                      carrier_id: Carrier.carrier_default,
                                carrier_entry_id: input_control.carrier.id,
                                            peso: input_control.weight,
                                     qtde_volume: input_control.volume,
                                          estado: target_client.estado,
                                          cidade: target_client.cidade,
                                      date_entry: input_control.date_receipt,
                                            data: data_scheduling,
                                      observacao: ""
                                                 )
      #puts ">>>>>>>>>>>>>>>> Criar Ordem de Servico Logistica"
      ordem_service.ordem_service_logistics.create!(driver_id: input_control.driver.id,
                                                        placa: input_control.place,
                                                         peso: input_control.weight,
                                                  qtde_volume: input_control.volume)
      #puts ">>>>>>>>>>>>>>>> Importar dados da NFE XML para NFE Keys"
      nfe_xmls.each do |nfe|
        #byebug
        take_dae = input_control.carrier_credentials? && target_client.client_credential_sefaz == false
        ordem_service.nfe_keys.create!(nfe: nfe.numero,
                                    chave: nfe.chave,
                                   nfe_id: ordem_service.id,
                                 nfe_type: "OrdemService",
                          nfe_source_type: nfe.nfe_type,
                              remessa_ype: input_control.shipment,
                                     peso: nfe.peso,
                                   volume: nfe.volume,
                                  average: value_weight_average,
                  action_inspector_number: action_inspector_number,
                                 take_dae: take_dae,
                              qtde_pallet: nfe.qtde_pallet,
                              observation: nfe.observation
                                    )

        #puts ">>>>>>>>>>>>>>>> Importar produtos"
        nfe.item_input_controls.each do |item|
          ordem_service.item_ordem_services.create!( product_id: item.product_id,
                                                         number: item.number_nfe,
                                                           qtde: item.qtde_trib,
                                                          valor: item.valor,
                                                    unid_medida: item.unid_medida,
                                                 valor_unitario: item.valor_unitario,
                                           valor_unitario_comer: item.valor_unitario_comer
                                      )
          #puts ">>>>>>>>>>>>>>>>> se nota de palete lançar no controle de palete"
          # if nfe.equipamento == NfeXml::TipoEquipamento::PALETE
          #   ControlPallet.create!(
          #                         client_id: source_client.id,
          #                        carrier_id: input_control.carrier.id,
          #                              data: input_control.date_receipt,
          #                               qte: item.qtde_trib,
          #                              tipo: ControlPallet::CreditoDebito::ENTRADA,
          #                               nfe: nfe.numero,
          #                      nfe_original: nfe.chave,
          #                              peso: nfe.peso,
          #                            volume: nfe.volume,
          #                            status: ControlPallet::TipoStatus::ABERTO,
          #                         historico: "Entrada de Paletes pela Remessa de Entrada. No: #{input_control.id} "
          #                       )
          # end

        end

        NfeXml.where(id: nfe.id).update_all(create_os: NfeXml::TipoOsCriada::SIM,
                              action_inspector_number: action_inspector_number,
                                             take_dae: take_dae)
      end
      #puts ">>>>>>>>>>>>>>>> update peso e volume:"
      ordem_service.set_peso_and_volume

    end
  end

  def get_ordem_services
    # os = []
    # self.nfe_xmls.each do |item|
    #   clients << item.target_client.nome
    # end
    # clients
  end

  def nfe_xmls_client(numero)
    clients = []
    self.nfe_xmls.where(numero: numero).each do |item|
      clients << item.target_client.nome
    end
    clients
  end

  def nfe_xmls_city(numero)
    cities = []
    self.nfe_xmls.where(numero: numero).each do |item|
      cities << "#{item.target_client.cidade}/#{item.target_client.estado}"
    end
    cities
  end

  def nfe_xmls_clients
    clients = []
    nfes_number = self.comments.last.observation.gsub(" ","").gsub('[','').gsub(']','').split(',')
    self.nfe_xmls.where(numero: nfes_number).select(:target_client_id).uniq.each do |item|
      clients << item.target_client.nome
    end
    puts ">>>>>>>>>>>>>>> number NFE: #{nfes_number}"
    clients
  end

  def nfe_xmls_cities
    cities = []
    nfes_number = self.comments.last.observation.gsub(" ","").gsub('[','').gsub(']','').split(',')
    self.nfe_xmls.where(numero: nfes_number).select(:target_client_id).uniq.each do |item|
      cities << "#{item.target_client.cidade}/#{item.target_client.estado}"
    end
    cities
  end

  def nfe_xmls_volume
    vol = 0.00
    nfes_number = self.comments.last.observation.gsub(" ","").gsub('[','').gsub(']','').split(',')
    self.nfe_xmls.where(numero: nfes_number).each do |item|
      vol += item.volume
      #cities << "#{item.target_client.cidade}/#{item.target_client.estado}"
    end
    vol
  end

  def feed
    Comment.where("comment_type = ? and comment_id = ?", "InputControl", self.id)
  end

  def feed_cancellations
    Cancellation.where("cancellation_type = ? and cancellation_id = ?", "InputControl", self.id)
  end

  def self.recebimento_descarga_historic
    conf = ConfigSystem.where(config_key: 'HISTORIC_RECEIVED_DISCHARGE_DEFAULT').first
    conf.config_value.to_i
  end

  def self.recebimento_descarga_cost_center
    conf = ConfigSystem.where(config_key: 'COST_CENTER_DEFAULT').first
    conf.config_value.to_i
  end

  def self.recebimento_descarga_sub_cost_center
    conf = ConfigSystem.where(config_key: 'SUB_COST_CENTER_DEFAULT').first
    conf.config_value.to_i
  end

  def self.recebimento_descarga_sub_cost_center_three
    conf = ConfigSystem.where(config_key: 'SUB_COST_CENTER_THREE_DEFAULT').first
    conf.config_value.to_i
  end

  def pending_all?
    self.create_ordem_service_pending? ||
    self.products_pending?
  end

  def pending_all
    pendings = []
    pendings.append('Existe O.S a ser criada.') if self.create_ordem_service_pending?
    pendings.append('Existe produtos para ser configurar os pallets.') if self.products_pending?
    pendings
  end

  def create_ordem_service_pending?
    positivo = false
    nfe_xmls.each do |item|
      #puts ">>>>> O.S: #{item.ordem_service_id} - Count: #{item.ordem_service.nfs_keys.count}"
      if item.equipamento == NfeXml::TipoEquipamento::NOTA_FISCAL
        positivo = item.ordem_service(NfeXml::TypeOrdemServiceController::INPUT_CONTROL).blank?
      end
      return true if positivo == true
    end
    positivo
  end

  def products_pending?
    positivo = false
    self.item_input_controls.each do |item|
      positivo = item.product.box_by_pallet == 0 ? true : false
      return true if positivo == true
    end
    positivo
  end

  def self.add_nfe_xml_input_control(input_control, array_nfe_xml)
    #if self.products_pending?
    begin
      #byebug
      ActiveRecord::Base.transaction do
        array_nfe_xml.each do |xml|
          #byebug
          nfe_xml = NfeXml.where(chave: xml).first
          file = "#{Rails.root.join('public')}" + nfe_xml.asset.url(:original, timestamp: false)
          nfe = NFe::NotaFiscal.new.load_xml_serealize(file)
          NfeXml.processado.is_not_input.where(chave: xml).update_all(nfe_type: "InputControl", nfe_id: input_control.id)
          NfeXml.product_create_or_update_xml('input_controls', input_control, nfe_xml, nfe)
          InputControls::SetWeightAndVolumeService.new(input_control).call
        end
        input_control.nfe_xmls.each do |nfe_xml|
          NfeXml.where(id: nfe_xml.id).update_all(qtde_pallet_calc: nfe_xml.item_input_controls.sum(:qtde_pallet))
        end
        return {success: true, message: "XML adicionado na remessa de entrada #{input_control.id} com sucesso."}
      end

    rescue => e
      puts e.message
      return {success: false, message: e.message}
    end
    #else
    #  return {success: false, message: "Existe produtos para ser configurar os pallets."}
    #end
	end

  def driver_checkin?
    # Um motorista pode fazer vários checkins no dia
    # Mas só pode fazer um novo checkin caso ele tenha feito checkout
    # verificar se o motorista fez checkin na L7
    Checkin.input_control.input.the_day.where(driver_cpf: self.driver.cpf).present?
  end

#  private
    def get_number_nfe_xmls
      nfes = []
      self.nfe_xmls.each do |n|
        nfes << n.numero
      end
      nfes
    end

end

    # Location.group(:city, :province, :country)
    #     .select(:city, :province, :country, "SUM(images_girl_count) as sum_images_count")
    #     .order("sum_images_count DESC")
    #     .collect{ |location| [location.city, location.province, location.country, location.sum_images_count] }
