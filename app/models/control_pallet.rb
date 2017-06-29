class ControlPallet < ActiveRecord::Base
  belongs_to :client
  belongs_to :carrier
  belongs_to :input_control
  
  validates :client_id, :data, :tipo, :qte, presence: true
  validates :carrier_id, presence: true

  scope :order_desc, -> { order(id: :desc) }
  scope :open_entry, -> { where(tipo: CreditoDebito::ENTRADA, status: TipoStatus::ABERTO).order(id: :desc) }

  module TipoStatus
    ABERTO    = 0 # pallete que tem em stok
    AGENDADO  = 1
    OS_CRIADA = 2 # pallets que foi para embarque
    CONCLUIDO = 3 # pallets que foi entregue
  end

  module CreditoDebito
    SAIDA = -1
    ENTRADA = 1
  end

  def credito_debito
  	case self.tipo
  		when -1 then "Saida"
  		when  1	then "Entrada"
  		else ""
  	end
  end

  def status_name
    case self.status_name
      when 0 then "Aberto"
      when 1 then "OS_CRIADA"
      when 2 then "Fechado"
      else ""
    end
  end

  def self.create_ordem_service(options)
    source_client = Client.find(options[:source_client_id])
    target_client = Client.find(options[:target_client_id])
    qtde_total = 0
    hash_ids = options[:ids]
    ActiveRecord::Base.transaction do
      ordem_service = OrdemService.create!(source_client_id: source_client.id, 
                                           target_client_id: target_client.id, 
                                                       tipo: OrdemService::TipoOS::LOGISTICA,
                                                     estado: source_client.estado,
                                                     cidade: source_client.cidade)
      # motorista não identificado 105
      ordem_service.ordem_service_logistics.create!(driver_id: 105,
                                                        placa: "XXX-0000"
                                                    )
      hash_ids.each do |i|
        id = i[0].to_i 
        qtde_total += i[1].to_f
        control_pallet = ControlPallet.find(id)
        ordem_service.nfe_keys.create!(nfe: control_pallet.nfe, chave: control_pallet.nfe_original, volume: control_pallet.qte, peso: control_pallet.peso)
        ControlPallet.create!(client_id: control_pallet.client_id, 
                                   data: Date.today, 
                                    qte: control_pallet.qte, 
                                   tipo: CreditoDebito::SAIDA, 
                                    nfe: control_pallet.nfe,
                                    nfd: control_pallet.nfd,
                           nfe_original: control_pallet.nfe_original,
                           nfd_original: control_pallet.nfd_original,
                              historico: "Sainda de Pallets OS: #{ordem_service.id}", 
                                   peso: control_pallet.peso,
                                 volume: control_pallet.volume,
                                 status: TipoStatus::ABERTO,
                              carrier_id: 3 #carrier_id: 3 nao identificado
                              )
        ordem_service.set_peso_and_volume
      end

    end
  end

  def self.saldo(client=nil)
    #date.nil? ? CurrentAccount.sum('price*type_launche') : CurrentAccount.where(date_ocurrence: date).sum('price*type_launche')
    client.nil? ? ControlPallet.sum('qte*tipo') : ControlPallet.where(client_id: client).sum('qte*tipo')
  end  

  def self.entrada(client=nil)
    client.nil? ? ControlPallet.where(tipo: CreditoDebito::ENTRADA).sum(:qte) : ControlPallet.where(client_id: client, tipo: CreditoDebito::ENTRADA).sum(:qte)
  end

  def self.saida(client=nil)
    client.nil? ? ControlPallet.where(tipo: CreditoDebito::SAIDA).sum(:qte) : ControlPallet.where(client_id: client, tipo: CreditoDebito::SAIDA).sum(:qte)
  end

end
