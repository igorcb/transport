class InputControl < ActiveRecord::Base
  validates :carrier_id, :driver_id, presence: true
	validates :place, :date_entry, :time_entry, presence: true

  belongs_to :carrier
  belongs_to :driver

  has_many :nfe_xmls, class_name: "NfeXml", foreign_key: "nfe_id", :as => :nfe, dependent: :destroy
  accepts_nested_attributes_for :nfe_xmls, allow_destroy: true, :reject_if => :all_blank

  has_many :item_input_controls
  

  after_save :processa_nfe_xmls

  before_create do |cte|
   set_values
  end 

  VALOR_DA_TONELADA = 25

  module TipoCarga
    BATIDA = false
    PALETIZADA  = true
  end

  def palletized_status
    case self.palletized
      when false then "Nao"
      when true then "Sim"
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


  def self.create_ordem_service_input_controls(params = {})
    puts ">>>>>>>>>>>>  params: #{params.to_s}"
    input_control = InputControl.find(params[:id])
    nfe_xmls = input_control.nfe_xmls.not_create_os.where(id: params[:nfe])
    target_client = nfe_xmls.first.target_client
    source_client = nfe_xmls.first.source_client
    ActiveRecord::Base.transaction do
      puts ">>>>>>>>>>>>>>>> Criar Ordem de Servico"
      ordem_service = OrdemService.create!( tipo: OrdemService::TipoOS::LOGISTICA,
                                input_control_id: input_control.id,
                                target_client_id: target_client.id, 
                                source_client_id: source_client.id,
                               billing_client_id: source_client.id,
                                      carrier_id: input_control.carrier.id,
                                            peso: input_control.weight, 
                                     qtde_volume: input_control.volume,
                                          estado: target_client.estado,
                                          cidade: target_client.cidade,
                                      date_entry: input_control.date_entry,
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
        NfeXml.where(id: nfe.id).update_all(create_os: NfeXml::TipoOsCriada::SIM)
      end
      puts ">>>>>>>>>>>>>>>> Importar produtos"
      input_control.item_input_controls.each do |item|
        ordem_service.item_ordem_services.create!( product_id: item.product_id,
                                                       number: item.number_nfe,
                                                         qtde: item.qtde_trib,
                                                  unid_medida: item.valor,
                                               valor_unitario: item.valor_unitario,
                                         valor_unitario_comer: item.valor_unitario_comer
                                    )
      end

    end
  end

end
