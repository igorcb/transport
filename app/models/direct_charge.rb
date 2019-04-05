class DirectCharge < ActiveRecord::Base
  validates :carrier_id, :driver_id, presence: true
	validates :place, :date_charge, presence: true
  validates :shipment, presence: true, uniqueness: true

  belongs_to :carrier, required: false
  belongs_to :driver, required: false
  belongs_to :user, class_name: "User", foreign_key: "user_id", required: false
  belongs_to :billing_client, class_name: "Client", foreign_key: "billing_client_id", required: false
  belongs_to :client_table_price, required: false
  belongs_to :type_service, required: false
  belongs_to :stretch_route, required: false

  #belongs_to :supplier, class_name: "Supplier", foreign_key: "supplier_id", polymorphic: true
  has_one :offer_charge

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

  #default_scope { order(date_charge: :desc, id: :desc) }

  #before_save { |item| item.email = email.downcase }
  RECEBIMENTO_DESCARGA_HISTORIC = 100
  RECEBIMENTO_DESCARGA_PAYMENT_METHOD = 2
  RECEBIMENTO_DESCARGA_COST_CENTER = 81
  RECEBIMENTO_DESCARGA_SUB_COST_CENTER = 269
  RECEBIMENTO_DESCARGA_SUB_COST_CENTER_THREE = 160

  VALUE_DISCHARGE = 0.88 #POR TONELADA
  VALOR_DA_TONELADA = 25

  after_save :processa_nfe_xmls

  after_create do |offer|
    update_offer_charge
  end

  before_create do |cte|
   set_values
  end

  before_save do |item|
    item.place = place.upcase
    item.place_cart = place_cart.upcase
    #item.place_cart_2 = place_cart_2.upcase
  end

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
    # peso = self.nfe_xmls.sum(:peso)
    # volume = self.nfe_xmls.sum(:volume)
    # valor_total = peso * valor_kg
    # ActiveRecord::Base.transaction do
    #   puts "peso: #{peso} and volume: #{volume}"
    #   DirectCharge.where(id: self.id).update_all(weight: peso, volume: volume, value_total: valor_total)
    # end
    DirectCharges::SetWeightAndVolumeService.new(self).call
  end

  def update_offer_charge
    ActiveRecord::Base.transaction do
      offer = OfferCharge.where(shipping: self.shipment).first
      OfferCharge.where(shipping: self.shipment).update_all(direct_charge_id: self.id, status: OfferCharge::TypeStatus::CLOSE)
      DirectCharge.where(id: self.id).update_all(offer_charge_id: offer.id) if offer.present?
    end
  end

  def vehicle_horse
    Vehicle.where(placa: self.place).first
  end

  def vehicle_cart_first
    Vehicle.where(placa: self.place_cart).first
  end

  def vehicle_cart_second
    Vehicle.where(placa: self.place_cart_2).first
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

  def self.add_nfe_xml_direct_charge(direct_charge, array_nfe_xml)
    begin
      #byebug
      ActiveRecord::Base.transaction do
        array_nfe_xml.each do |xml|
          #byebug
          nfe_xml = NfeXml.where(chave: xml).first
          file = "#{Rails.root.join('public')}" + nfe_xml.asset.url(:original, timestamp: false)
          nfe = NFe::NotaFiscal.new.load_xml_serealize(file)
          NfeXml.processado.is_not_input.where(chave: xml).update_all(nfe_type: "DirectCharge", nfe_id: direct_charge.id)
          NfeXml.product_create_or_update_xml('direct_charges', direct_charge, nfe_xml, nfe)
          DirectCharges::SetWeightAndVolumeService.new(direct_charge).call
        end
        return {success: true, message: "XML adicionado na Carga Direta No: #{direct_charge.id} com sucesso."}
      end

    rescue => e
      puts e.message
      return {success: false, message: e.message}
    end
	end

  def finish_typing
    return_value = false
    begin
      ActiveRecord::Base.transaction do
        #criar contas a receber
        # if self.charge_discharge?
        #   AccountReceivable.create!(
        #                          type_account: AccountReceivable::TypeAccount::MOTORISTA,
        #                           client_type: AccountReceivable::TypeAccountName::MOTORISTA,
        #                             client_id: self.driver_id,
        #                      input_control_id: self.id,
        #                        cost_center_id: RECEBIMENTO_DESCARGA_COST_CENTER,
        #                    sub_cost_center_id: RECEBIMENTO_DESCARGA_SUB_COST_CENTER,
        #              sub_cost_center_three_id: RECEBIMENTO_DESCARGA_SUB_COST_CENTER_THREE,
        #                     payment_method_id: RECEBIMENTO_DESCARGA_PAYMENT_METHOD,
        #                           historic_id: RECEBIMENTO_DESCARGA_HISTORIC,
        #                       data_vencimento: Date.today,
        #                             documento: self.id,
        #                                 valor: self.value_total,
        #                            observacao: "RECEBIMENTO DE DESCARGA REMESSA No: #{self.id}, NF-e: #{get_number_nfe_xmls}",
        #                                status: AccountReceivable::TipoStatus::ABERTO
        #                          )
        #   #colocar remessa como digitação finalizada
        #   self.update_attributes(status: InputControl::TypeStatus::FINISH_TYPING)
        # end
        self.update_attributes(status: DirectCharge::TypeStatus::FINISH_TYPING)
        return {success: true, message: "Direct Charge finish_typing was successfully "}
      end
    # rescue exception
    #   return_value = false
    #   raise ActiveRecord::Rollback
    # end

    rescue => e
      return_value = false
      puts e.message
      return {success: false, message: e.message}
    end
  end

  def status_finish_typing?
    self.status == TypeStatus::FINISH_TYPING
  end

  #mudar o nome do metodo para create_ordem_service_direct_charge
  def self.create_ordem_service_input_controls(params = {})
    puts ">>>>>>>>>>>>  params: #{params.to_s}"
    input_control = DirectCharge.find(params[:id])
    nfe_xmls = input_control.nfe_xmls.nfe.not_create_os.where(id: params[:nfe])
    total_weight = input_control.nfe_xmls.nfe.sum(:peso).to_f
    total_weight_nfe_select = input_control.nfe_xmls.nfe.not_create_os.where(id: params[:nfe]).sum(:peso)

    target_client = nfe_xmls.first.target_client
    source_client = nfe_xmls.first.source_client
    billing_client = input_control.billing_client

    value_weight_average = BigDecimal.new(0)
    value_weight_average_select = BigDecimal.new(0)

    if input_control.client_table_price.present?
      value_weight_average = input_control.client_table_price.minimum_total_freight / total_weight
      value_freight_select = total_weight_nfe_select * value_weight_average
    end

    #carrier = Carrier.find(3) #DEFAULT NÃO INFORMADO, ATUALIZAR NO EMBARQUE
    ActiveRecord::Base.transaction do
      puts ">>>>>>>>>>>>>>>> Criar Ordem de Servico"
      ordem_service = OrdemService.create!( tipo: OrdemService::TipoOS::LOGISTICA,
                                direct_charge_id: input_control.id,
                                target_client_id: target_client.id,
                                source_client_id: source_client.id,
                               billing_client_id: billing_client.id,
                                      carrier_id: Carrier.carrier_default,
                                carrier_entry_id: input_control.carrier.id,
                                            peso: input_control.weight,
                                     qtde_volume: input_control.volume,
                                          estado: target_client.estado,
                                          cidade: target_client.cidade,
                                      date_entry: input_control.date_charge,
                                      observacao: ""
                                                 )
      puts ">>>>>>>>>>>>>>>> Criar Ordem de Servico Logistica"
      ordem_service.ordem_service_logistics.create!(driver_id: input_control.driver.id,
                                                        placa: input_control.place,
                                                         peso: input_control.weight,
                                                  qtde_volume: input_control.volume)
      # puts ">>>>>>>>>>>>>>>> Criar Ordem de Servico Tipo de Servico"
      # ordem_service.ordem_service_type_service.create!(type_service_id: input_control.client_table_price.type_service_id,
      #                                            client_table_price_id: input_control.client_table_price_id,
      #                                                            valor: value_freight_select
      #                                                  )

      puts ">>>>>>>>>>>>>>>> Importar dados da NFE XML para NFE Keys"
      nfe_xmls.each do |nfe|
        ordem_service.nfe_keys.create!(nfe: nfe.numero,
                                    chave: nfe.chave,
                                   nfe_id: ordem_service.id,
                                 nfe_type: "OrdemService",
                          nfe_source_type: nfe.nfe_type,
                              remessa_ype: input_control.shipment,
                                     peso: nfe.peso,
                                  average: value_weight_average,
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

        end

        NfeXml.where(id: nfe.id).update_all(create_os: NfeXml::TipoOsCriada::SIM)
      end
      #puts ">>>>>>>>>>>>>>>> update peso e volume"
      ordem_service.set_peso_and_volume

    end
  end


end
