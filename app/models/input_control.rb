class InputControl < ActiveRecord::Base
  validates :carrier_id, :driver_id, presence: true
	validates :place, :date_entry, :time_entry, presence: true

  belongs_to :carrier
  belongs_to :driver
  belongs_to :user_received, class_name: "User", foreign_key: "received_user_id"

  has_one :account_receivable

  has_many :nfe_xmls, class_name: "NfeXml", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :nfe_xmls, allow_destroy: true, :reject_if => :all_blank
  
  has_many :ordem_services
  has_many :item_input_controls

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  #before_save { |item| item.email = email.downcase }
  RECEBIMENTO_DESCARGA_HISTORIC = 100
  RECEBIMENTO_DESCARGA_PAYMENT_METHOD = 2
  RECEBIMENTO_DESCARGA_COST_CENTER = 81
  RECEBIMENTO_DESCARGA_SUB_COST_CENTER = 269
  RECEBIMENTO_DESCARGA_SUB_COST_CENTER_THREE = 160

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
                                 observacao: "RECEBIMENTO DE DESCARGA REMESSA No: #{self.id}",
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
        ControlPallet.create!(
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
                      historico: "Entrada de Paletes pela Remessa de Entrada. No: #{input_control.id} "
                            )
        NfeXml.where(id: nfe.id).update_all(create_os: NfeXml::TipoOsCriada::SIM)
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
                                                    unid_medida: item.valor,
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

end
