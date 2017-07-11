class InputControl < ActiveRecord::Base
  validates :carrier_id, :driver_id, presence: true
	validates :place, :date_entry, :time_entry, presence: true

  belongs_to :carrier
  belongs_to :driver
  belongs_to :user_received, class_name: "User", foreign_key: "received_user_id"

  has_many :nfe_xmls, class_name: "NfeXml", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :nfe_xmls, allow_destroy: true, :reject_if => :all_blank
  
  has_many :ordem_services
  has_many :item_input_controls

  has_one :account_receivable

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  has_one :cancellation, class_name: "Cancellation", foreign_key: "cancellation_id"
  has_many :cancellations, class_name: "Cancellation", foreign_key: "cancellation_id", :as => :cancellation, dependent: :destroy
  accepts_nested_attributes_for :cancellations, allow_destroy: true, :reject_if => :all_blank

  has_many :comments, class_name: "Comment", foreign_key: "comment_id", :as => :comment, dependent: :destroy

  scope :not_discharge_weight, -> { where(not_discharge: false) }

  #before_save { |item| item.email = email.downcase }
  RECEBIMENTO_DESCARGA_HISTORIC = 100
  RECEBIMENTO_DESCARGA_PAYMENT_METHOD = 2
  RECEBIMENTO_DESCARGA_COST_CENTER = 81
  RECEBIMENTO_DESCARGA_SUB_COST_CENTER = 269
  RECEBIMENTO_DESCARGA_SUB_COST_CENTER_THREE = 160

  VALUE_DISCHARGE = 0.88 #POR TONELADA

  before_save do |item| 
    item.place = place.upcase 
    item.place_cart = place_cart.upcase 
    item.place_cart_2 = place_cart_2.upcase 
  end
  
  before_create do |cte|
   set_values
  end 

  after_save :processa_nfe_xmls

  VALOR_DA_TONELADA = 25

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
  end #ordem do processo OPEN, FINISH TYPING, CLOSE, BILLIED

  def self.ransackable_attributes(auth_object = nil)
    ['id','carrier','driver','place','date_entry', 'date_receipt', 'status']
  end

  def self.select_date_receipt
    InputControl.joins(:nfe_xmls).where(not_discharge: false, :nfe_xmls => {equipamento: NfeXml::TipoEquipamento::NOTA_FISCAL}).where.not(date_receipt: nil)
                .select(:date_receipt, "SUM(nfe_xmls.peso) as peso", "coalesce(SUM(nfe_xmls.peso_liquido),0) AS peso_liquido, AVG(nfe_xmls.peso) as media")
                .group(:date_receipt)
                .order(date_receipt: :desc)
                .collect {|input| [input.date_receipt, input.peso, input.peso_liquido, input.media]}

  end

 def self.select_date_receipt_total
    InputControl.joins(:nfe_xmls).where(not_discharge: false, :nfe_xmls => {equipamento: NfeXml::TipoEquipamento::NOTA_FISCAL}).where.not(date_receipt: nil)
                .select("SUM(nfe_xmls.peso) as peso", "coalesce(SUM(nfe_xmls.peso_liquido),0) AS peso_liquido, AVG(nfe_xmls.peso) as media")
                .collect {|input| [input.peso, input.peso_liquido, input.media]}

  end


  def status_received?
    puts ">>>>>>>>>>>>>>>> Status: #{self.status_name} : Result: #{self.status == TypeStatus::RECEIVED}"
    self.status == TypeStatus::RECEIVED
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
    peso = self.nfe_xmls.sum(:peso)
    volume = self.nfe_xmls.sum(:volume)
    valor_total = peso * valor_kg
    ActiveRecord::Base.transaction do
      puts "peso: #{peso} and volume: #{volume}"
      InputControl.where(id: self.id).update_all(weight: peso, volume: volume, value_total: valor_total)
    end
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
    valor = valor_kg * self.peso
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
    puts ">>>>>>>>>>>> first: #{client.source_client_id}"
    clients.order(:id).each do |os|
      puts ">>>>>>>>>>>>. #{client.source_client_id} - #{os.source_client_id} - #{client.source_client_id == os.source_client_id}"
      positivo = client.source_client_id == os.source_client_id
      return false if positivo == false
    end
    positivo
  end

  def received
    # so pode informar recebimento se a remessa estiver no status FINISH_TYPING
    # fazer checagem se necessario
    return_value = false
    begin
      ActiveRecord::Base.transaction do
        return_value = true
        self.update_attributes(date_receipt: Date.current, status: InputControl::TypeStatus::RECEIVED)
      end
    rescue exception
      return_value = false
      raise ActiveRecord::Rollback
    end
  end

  def finish_typing
    return_value = false
    begin
      ActiveRecord::Base.transaction do
        #criar contas a receber
        AccountReceivable.create!(
                               type_account: AccountReceivable::TypeAccount::MOTORISTA,
                                client_type: AccountReceivable::TypeAccountName::MOTORISTA,
                                  client_id: self.driver_id,
                           input_control_id: self.id,
                             cost_center_id: RECEBIMENTO_DESCARGA_COST_CENTER,
                         sub_cost_center_id: RECEBIMENTO_DESCARGA_SUB_COST_CENTER,
                   sub_cost_center_three_id: RECEBIMENTO_DESCARGA_SUB_COST_CENTER_THREE,
                          payment_method_id: RECEBIMENTO_DESCARGA_PAYMENT_METHOD, 
                                historic_id: RECEBIMENTO_DESCARGA_HISTORIC,
                            data_vencimento: Date.today,
                                  documento: self.id,
                                      valor: self.value_total,
                                 observacao: "RECEBIMENTO DE DESCARGA REMESSA No: #{self.id}, NF-e: #{get_number_nfe_xmls}",
                                     status: AccountReceivable::TipoStatus::ABERTO
                               )
        #colocar remessa como digitação finalizada
        self.update_attributes(status: InputControl::TypeStatus::FINISH_TYPING)
      end
    rescue exception
      return_value = false
      raise ActiveRecord::Rollback
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
               input_control_id: input_control.id,
                      historico: "Entrada de Paletes pela Remessa de Entrada. No: #{input_control.id} "
                            )
        NfeXml.where(id: nfe.id).update_all(create_os: NfeXml::TipoOsCriada::SIM)
        ControlPalletMailer.notification_pallets(control_pallet).deliver!
      end

    end
  end    

  def self.create_ordem_service_input_controls(params = {})
    puts ">>>>>>>>>>>>  params: #{params.to_s}"
    input_control = InputControl.find(params[:id])
    nfe_xmls = input_control.nfe_xmls.nfe.not_create_os.where(id: params[:nfe])
    target_client = nfe_xmls.first.target_client
    source_client = nfe_xmls.first.source_client
    carrier = Carrier.find(3) #DEFAULT NÃO INFORMADO, ATUALIZAR NO EMBARQUE
    ActiveRecord::Base.transaction do
      puts ">>>>>>>>>>>>>>>> Criar Ordem de Servico"
      ordem_service = OrdemService.create!( tipo: OrdemService::TipoOS::LOGISTICA,
                                input_control_id: input_control.id,
                                target_client_id: target_client.id, 
                                source_client_id: source_client.id,
                               billing_client_id: source_client.id,
                                      carrier_id: carrier.id,
                                carrier_entry_id: input_control.carrier.id,
                                            peso: input_control.weight, 
                                     qtde_volume: input_control.volume,
                                          estado: target_client.estado,
                                          cidade: target_client.cidade,
                                      date_entry: input_control.date_receipt,
                                      observacao: ""
                                                 )
      puts ">>>>>>>>>>>>>>>> Criar Ordem de Servico Logistica"
      ordem_service.ordem_service_logistics.create!(driver_id: input_control.driver.id, 
                                                        placa: input_control.place, 
                                                         peso: input_control.weight, 
                                                  qtde_volume: input_control.volume)
      puts ">>>>>>>>>>>>>>>> Importar dados da NFE XML para NFE Keys"
      nfe_xmls.each do |nfe|
        ordem_service.nfe_keys.create!(nfe: nfe.numero,
                                    chave: nfe.chave,
                                   nfe_id: ordem_service.id,
                                 nfe_type: "OrdemService",
                                     peso: nfe.peso,
                                   volume: nfe.volume
                                    )

        puts ">>>>>>>>>>>>>>>> Importar produtos"
        nfe.item_input_controls.each do |item|
          ordem_service.item_ordem_services.create!( product_id: item.product_id,
                                                         number: item.number_nfe,
                                                           qtde: item.qtde_trib,
                                                          valor: item.valor,
                                                    unid_medida: item.unid_medida,
                                                 valor_unitario: item.valor_unitario,
                                           valor_unitario_comer: item.valor_unitario_comer
                                      )
          puts ">>>>>>>>>>>>>>>>> se nota de palete lançar no controle de palete"
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
        
        NfeXml.where(id: nfe.id).update_all(create_os: NfeXml::TipoOsCriada::SIM)
      end
      puts ">>>>>>>>>>>>>>>> update peso e volume"
      ordem_service.set_peso_and_volume

    end
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
