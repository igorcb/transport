class ControlPallet < ActiveRecord::Base

  validates :responsible_type, presence: true

  #belongs_to :responsible, class_name: "Supplier", foreign_key: "supplier_id", polymorphic: true, required: false

  enum tipo: {credito: 1, debito: -1}
  enum responsible_type: {supplier: "Supplier", driver: "Driver", client: "Client", employee: "Employee", carrier: "Carrier"}
  enum type_product: {pallet: 1, chapatex: 2, bigbag: 3}
  enum status: [:open, :scheduled, :os_created, :done]

  scope :order_desc, -> { order(id: :desc) }
  # scope :open_entry, -> { where(tipo: CreditoDebito::ENTRADA, status: TipoStatus::ABERTO).order(id: :desc) }
  # scope :not_generate_ordem_service, -> { where(generate_ordem_service: false) }
  # scope :generate_ordem_service, -> { where(generate_ordem_service: true) }
  #
  # module TipoStatus
  #   ABERTO    = 0 # pallete que tem em stok
  #   AGENDADO  = 1
  #   OS_CRIADA = 2 # pallets que foi para embarque
  #   CONCLUIDO = 3 # pallets que foi entregue
  # end
  #
  # module CreditoDebito
  #   SAIDA = -1
  #   ENTRADA = 1
  # end
  #

  def responsible
    case self.responsible_type
    when "supplier" then supplier = Supplier.where(id: self.responsible_id).first
    when "driver" then supplier = Driver.where(id: self.responsible_id).first
    when "client" then supplier = Client.where(id: self.responsible_id).first
    when "employee" then supplier = Employee.where(id: self.responsible_id).first
    when "carrier" then supplier = Carrier.where(id: self.responsible_id).first
    end
    supplier
  end
  # def credito_debito
  # 	case self.tipo
  # 		when -1 then "Saida"
  # 		when  1	then "Entrada"
  # 		else ""
  # 	end
  # end
  #
  # def status_name
  #   case self.status_name
  #     when 0 then "Aberto"
  #     when 1 then "OS_CRIADA"
  #     when 2 then "Fechado"
  #     else ""
  #   end
  # end
  #
  # def self.create_ordem_service(options)
  #   source_client = Client.find(options[:source_client_id])
  #   target_client = Client.find(options[:target_client_id])
  #   qtde_total = 0
  #   hash_ids = options[:ids]
  #   ActiveRecord::Base.transaction do
  #
  #     ordem_service = OrdemService.create!(source_client_id: source_client.id,
  #                                          target_client_id: target_client.id,
  #                                                      tipo: OrdemService::TipoOS::LOGISTICA,
  #                                                    estado: source_client.estado,
  #                                                    cidade: source_client.cidade)
  #     # motorista não identificado 105
  #     ordem_service.ordem_service_logistics.create!(driver_id: 105,
  #                                                       placa: "XXX-0000"
  #                                                   )
  #     hash_ids.each do |i|
  #       id = i[0].to_i
  #       qtde_total += i[1].to_f
  #       ControlPallet.where(id: id).update_all(generate_ordem_service: true)
  #       control_pallet = ControlPallet.find(id)
  #       # control_pallet.generate_ordem_service = true
  #       # control_pallet.save!
  #       ordem_service.nfe_keys.create!(nfe: control_pallet.nfe, chave: control_pallet.nfe_original, volume: control_pallet.qte, peso: control_pallet.peso)
  #       ControlPallet.create!(client_id: control_pallet.client_id,
  #                                  data: Date.today,
  #                                   qte: control_pallet.qte,
  #                                  tipo: CreditoDebito::SAIDA,
  #                                   nfe: control_pallet.nfe,
  #                                   nfd: control_pallet.nfd,
  #                          nfe_original: control_pallet.nfe_original,
  #                          nfd_original: control_pallet.nfd_original,
  #                             historico: "Saida de Pallets OS: #{ordem_service.id}",
  #                                  peso: control_pallet.peso,
  #                                volume: control_pallet.volume,
  #                                status: TipoStatus::ABERTO,
  #                             carrier_id: 3 #carrier_id: 3 nao identificado
  #                             )
  #       ordem_service.set_peso_and_volume
  #     end
  #
  #   end
  # end
  #
  # def self.saldo(client=nil)
  #   #date.nil? ? CurrentAccount.sum('price*type_launche') : CurrentAccount.where(date_ocurrence: date).sum('price*type_launche')
  #   client.nil? ? ControlPallet.sum('qte*tipo') : ControlPallet.where(client_id: client).sum('qte*tipo')
  # end
  #
  # def self.entrada(client=nil)
  #   client.nil? ? ControlPallet.where(tipo: CreditoDebito::ENTRADA).sum(:qte) : ControlPallet.where(client_id: client, tipo: CreditoDebito::ENTRADA).sum(:qte)
  # end
  #
  # def self.saida(client=nil)
  #   client.nil? ? ControlPallet.where(tipo: CreditoDebito::SAIDA).sum(:qte) : ControlPallet.where(client_id: client, tipo: CreditoDebito::SAIDA).sum(:qte)
  # end

end
