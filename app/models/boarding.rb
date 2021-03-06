class Boarding < ActiveRecord::Base
  validates :carrier_id, presence: true
  validates :driver_id, presence: true
  validates :status, presence: true
  #validates_associated :ordem_services

  belongs_to :carrier, required: false
  belongs_to :driver, required: false

  belongs_to :started_user, class_name: "User", foreign_key: "started_user_id", required: false
  belongs_to :confirmed_user, class_name: "User", foreign_key: "confirmed_user_id", required: false
  belongs_to :driver_checkin_user, class_name: "User", foreign_key: "driver_checkin_user_id", required: false
  belongs_to :insurer, required: false

  has_one :account_payable
  has_many :account_payables

  has_many :ordem_services, :through => :boarding_items
  has_many :nfe_keys, :through => :ordem_services

  has_many :boarding_items
  #accepts_nested_attributes_for :boarding_items, allow_destroy: true, :reject_if => :all_blank
  has_many :boarding_vehicles
  has_many :vehicles, :through => :boarding_vehicles
  accepts_nested_attributes_for :boarding_vehicles, allow_destroy: true, :reject_if => :all_blank

  has_many :cte_keys, class_name: "CteKey", foreign_key: "cte_id", :as => :cte, dependent: :destroy
  accepts_nested_attributes_for :cte_keys, allow_destroy: true, :reject_if => :all_blank

  has_one :cancellation, class_name: "Cancellation", foreign_key: "cancellation_id"
  has_many :cancellations, class_name: "Cancellation", foreign_key: "cancellation_id", :as => :cancellation, dependent: :destroy
  accepts_nested_attributes_for :cancellations, allow_destroy: true, :reject_if => :all_blank

  has_many :comments, class_name: "Comment", foreign_key: "comment_id", :as => :comment, dependent: :destroy
  #has_many :commentaries, class_name: "Comment", foreign_key: "comment_id", :as => :comment, dependent: :destroy
  has_many :internal_comments, class_name: "InternalComment", foreign_key: "comment_id", :as => :comment, dependent: :destroy
  # has_many :internal_commentaries, class_name: "InternalComment", foreign_key: "comment_id", :as => :comment, dependent: :destroy


  has_many :control_pallet_internals

  has_many :breakdowns, as: :breakdown, dependent: :destroy
  accepts_nested_attributes_for :breakdowns, allow_destroy: true, reject_if: :all_blank

  has_many :sealings, as: :sealing, class_name: "Sealingwax", foreign_key: "sealing_id", dependent: :destroy
  accepts_nested_attributes_for :sealings, allow_destroy: true, reject_if: :all_blank

  scope :status_open, -> { includes(:driver).where(status: [TipoStatus::ABERTO, TipoStatus::EMBARCADO]).order("id desc") }
  scope :the_day, -> { includes(:driver).where(date_boarding: Date.current).order("id desc") }
  scope :status_boarding, -> { includes(:driver).where(status: TipoStatus::EMBARCADO).order("id desc") }
  scope :opened, ->  { includes(:driver).where(date_boarding: Date.current, status: TipoStatus::ABERTO).order("id desc") }
  scope :loading, -> { includes(:driver).where(date_boarding: Date.current, status: TipoStatus::INICIADO).order("id desc") }
  scope :boarded, -> { includes(:driver).where(date_boarding: Date.current, status: TipoStatus::EMBARCADO).order("id desc") }


  before_destroy :erase_boarding_items

  ZERO = 0.00

  # DRIVER_NOT_INFORMATION = 105
  # CARRIER_NOT_INFORMATION = 3

  before_save do |item|
    item.driver_checkin_palce_horse = driver_checkin_palce_horse.upcase if driver_checkin_palce_horse.present?
    item.driver_checkin_palce_cart_1 = driver_checkin_palce_cart_1.upcase if driver_checkin_palce_cart_1.present?
    item.driver_checkin_palce_cart_2 = driver_checkin_palce_cart_2.upcase if driver_checkin_palce_cart_2.present?
  end

  # before_create do |item|
  #   item.driver_checkin = false
  # end

  module TipoStatus
  	ABERTO = 0
  	EMBARCADO = 1
  	ENTREGUE = 2
    CANCELADO = 3
    INICIADO = 4
    REENTREGA = 5
    #FLOWUP - [Aberto, Iniciado, Embarcado, Entregue]
  end

  module TypeLocalEmbarque
    FORTALEZA = 1
    JUAZEIRO_DO_NORTE = 2
    SIMOES_FILHO = 3
  end

  def status_name
    case status
      when 0 then "Aberto"
      when 4 then "Iniciado"
      when 1 then "Embarcado"
      when 2 then "Entregue"
      when 3 then "Cancelado"
      when 5 then "REENTREGA"
      else "Não Informado"
    end
  end

  def local_embarque_name
    case local_embarque
      when 1 then "Fortaleza/CE"
      when 2 then "Juazeiro do Norte/CE"
      when 3 then "Simões Filho/BA"
      else "Não Informado"
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

  def self.ransackable_attributes(auth_object = nil)
    ['id', 'date_boarding', 'driver_id' ,'status', 'sealing', 'sealing_two', 'sealing_three']
  end

  def value_zero?
    self.value_boarding == 0 ||
    self.value_boarding.to_f == 0.00
  end

  def feed_cancellations
    Cancellation.where("cancellation_type = ? and cancellation_id = ?", "Boarding", self.id)
  end

  def feed_internal_comments
    InternalComment.where("comment_type = ? and comment_id = ?", "Boarding", self.id)
  end


  def erase_boarding_items
    ActiveRecord::Base.transaction do
      OrdemService.where(id: [self.boarding_items.ids]).update_all(status: OrdemService::TipoStatus::ABERTO)
      self.boarding_items.each do |item|
        item.destroy
      end
    end
  end

    # begin
    #   ActiveRecord::Base.transaction do
    #     offer_charge = cancel.cancellation_model
    #     OfferCharge.where(id: offer_charge.id).update_all(status: OfferCharge::TypeStatus::CANCEL)
    #     Cancellation.where(id: cancel.id).update_all(authorization_user_id: user, status: TipoStatus::CONFIRMADO)
    #     return true
    #   end
    #   rescue Exception => e
    #     puts e.message
    #     self.errors.add(:cancellation, e.message)
    #     return false
    # end

  def self.generate_shipping(ids)
    hash_ids = []
    ids.keys.each do |i|
      hash_ids << i.to_i
    end
    begin
      driver = Boarding.driver_not_information #Motorista Padrao - Motorista Não Identificado
      carrier = Boarding.carrier_not_information #Agent Padrao - Agent Não Identificado
      boarding = nil
      ActiveRecord::Base.transaction do
        boarding = Boarding.create(driver_id: driver, carrier_id: carrier, status: Boarding::TipoStatus::ABERTO)
        hash_ids.each do |os|
        	boarding.boarding_items.create!(ordem_service_id: os, delivery_number: 1)
        end
        OrdemService.where(id: hash_ids).update_all(status: OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
        boarding
      end
      rescue Exception => e
        puts e.message
        boarding.errors.add(:boarding, "#{e.message}. Por favor verificar se já foi gerado um embarque com a nota fiscal selecionada" )
        #Por favor verificar se já foi gerado um embarque com a nota fiscal selecionada
        boarding
    end
  end

  def check_status_ordem_service?
    positivo = true
    self.boarding_items.order(:delivery_number).each do |item|
      positivo = item.ordem_service.status == OrdemService::TipoStatus::EMBARCADO
      return false if positivo == false
    end
    positivo
  end

  def check_status_ordem_service_embarcado?
    positivo = true
    self.boarding_items.order(:delivery_number).each do |item|
      #puts "Status: #{item.ordem_service.status} - #{item.ordem_service.status == OrdemService::TipoStatus::EMBARCADO}"
      # if positivo = ((item.ordem_service.status == OrdemService::TipoStatus::EMBARCADO) or (item.ordem_service.status == OrdemService::TipoStatus::ENTREGA_EFETUADA))
      #   positivo = true
      # else
      #   positivo = false
      # end
      positivo = ((item.ordem_service.status == OrdemService::TipoStatus::EMBARCADO) or (item.ordem_service.status == OrdemService::TipoStatus::ENTREGA_EFETUADA) or (item.ordem_service.status == OrdemService::TipoStatus::FECHADO))
      return false if positivo == false
    end
    positivo
  end

  def check_status_ordem_service_entregue?
    positivo = true
    self.boarding_items.order(:delivery_number).each do |item|
      positivo = item.ordem_service.status == OrdemService::TipoStatus::ENTREGA_EFETUADA
      return false if positivo == false
    end
    positivo
  end

  def date_scheduling_present?
    positivo = false
    self.boarding_items.order(:delivery_number).each do |item|
      positivo = item.ordem_service.data.blank?
      return true if positivo == true
    end
    positivo
  end

  def billing_client_blank?
    # Deve retornar true se tiver ordem de servico que não tenha tomador de servico
    positivo = false
    boarding_items.each do |item|
      positivo = item.ordem_service.billing_client.nil?
      return true if positivo == true
    end
    positivo
  end

  def ordem_service_type_service_pending?
    positivo = false
    boarding_items.each do |item|
      positivo = item.ordem_service.ordem_service_type_service_pending?
      return true if positivo == true
    end
    positivo
  end

  def ordem_service_cte_pending?
    positivo = false
    boarding_items.each do |item|
      positivo = item.ordem_service.ordem_service_cte_pending?
      return true if positivo == true
    end
    positivo
  end

  def ordem_service_nfs_pending?
    positivo = false
    boarding_items.each do |item|
      positivo = item.ordem_service.ordem_service_nfs_pending?
      return true if positivo == true
    end
    positivo
  end

  def check_ordem_service_cte_and_nfs_pending?
    self.ordem_service_cte_pending? && self.ordem_service_nfs_pending?
  end

  def check_driver_restriction_with_client?
    positivo = false
    boarding_items.each do |item|
      positivo = DriverRestriction.where(driver_id: item.boarding.driver_id, client_id: item.ordem_service.client).present?
      return true if positivo == true
    end
    positivo
  end

  def value_not_boarding_present?
    self.value_boarding.blank? ||
    self.value_boarding.nil? ||
    self.value_zero?
  end

  def value_boarding_greater_than_value_insurance
    if self.insurer.present?
      self.value_boarding.to_f > self.insurer.ordered_expired.first.value.to_f
    end
  end

  def sealing_pending?
    # #self.sealing.blank? && self.sealing_two.blank? && self.sealing_three.blank?
    # #return false if ordem_service.type_direct_charge?
    # checkin = Checkin.the_day.input.where(driver_cpf: self.driver.cpf).last
    # if sealings.blank?
    #   return true
    # elsif checkin.nil?
    #   return true
    # elsif (checkin.door != self.sealings.count)
    #   return true
    # else
    #   false
    # end
    (qtde_doors.to_i == sealings.count)? false : true

  end

  def qtde_doors
    #boarding_vehicles.joins(:vehicle).sum(vehicles: {:door})
    boarding_vehicles.joins(:vehicle).sum("vehicles.door")
  end

  def pending?
    self.ordem_service_pending? ||
    self.nfe_dae_pending? ||
    self.date_boarding.blank? ||
    self.date_scheduling_present? ||
    self.billing_client_blank? ||
    self.carrier_id == Boarding.carrier_not_information ||
    self.driver_id == Boarding.driver_not_information ||
    self.driver.cnh_expired? ||
    check_driver_restriction_with_client? ||
    DriverRestriction.where(driver_id: self.driver_id).present? ||
    weight_exceeds_vehicle_capacity? ||
    check_annt_exist_vehicle_first? ||
    check_annt_exist_vehicle_second? ||
    check_annt_exipired_vehicle_first? ||
    check_annt_exipired_vehicle_second? ||
    check_vehicle_exist? ||
    check_type_vehicle_tracao_and_reboque?
    !check_all_ordem_service_have_payment_discharge?
  end

  def pending_services?
    self.ordem_service_type_service_pending? ||
    self.sealing_pending? ||
    self.driver.cnh_expired?
  end

  def pending_all?
    pending? || pending_services?
  end

  def pending
    pendings = []
    pendings.append('Existe Ordem de Serviço com remessa de entrada não recebida.') if self.ordem_service_pending?
    pendings.append('Existe NF-e com pendência de DAE.') if self.nfe_dae_pending?
    pendings.append('Data do Embarque não está presente.') if self.date_boarding.blank?
    #pendings.append('Valor do embarque não foi informado.') if self.date_boarding.blank?
    pendings.append('Data Agendamento O.S. não está presente.') if self.date_scheduling_present?
    pendings.append('Adicionar cliente para faturamento.') if self.billing_client_blank?
    pendings.append('Informe o motorista.') if self.driver_id == Boarding.driver_not_information
    pendings.append('Agente não informado.') if self.carrier_id == Boarding.carrier_not_information
    pendings.append('Motorista com restrição. Não pode efetuar entrega no cliente.') if check_driver_restriction_with_client?
    pendings.append('Motorista com restrição.') if DriverRestriction.where(driver_id: self.driver_id).present?
    pendings.append('CNH do motorista está vencida.') if self.driver.cnh_expired?
    pendings.append('Peso total acima da capacidade do veículo.') if self.weight_exceeds_vehicle_capacity?
    pendings.append('ANTT não existe para o primeiro veículo.') if check_annt_exist_vehicle_first?
    pendings.append('ANTT não existe para o segundo veículo.') if check_annt_exist_vehicle_second?
    pendings.append('Validade ANTT exipirada para primeiro veículo.') if check_annt_exipired_vehicle_first?
    pendings.append('Validade ANTT exipirada para segundo veículo. ') if check_annt_exipired_vehicle_second?
    pendings.append('Embarque deve ter um veiculo') if check_vehicle_exist?
    pendings.append('Embarque deve ter um veiculo TRACAO e um REBOQUE') if check_type_vehicle_tracao_and_reboque?
    pendings.append('Existe O.S sem pagamento de descarga.') if !check_all_ordem_service_have_payment_discharge?
    pendings
  end

  def pending_services
    pendings = []
    pendings.append('Existe Ordem de Serviço sem Tipo de Serviço .') if self.ordem_service_type_service_pending?
    pendings.append('Existe Ordem de Serviço sem CT-e ou NFS-e.') if self.check_ordem_service_cte_and_nfs_pending?
    pendings.append('Informar os lacres do embarque.') if self.sealing_pending?
    pendings.append('Qtde de Palletes do veículo é menor do que a qtde de pallets do embarque') if capacity_exceeded_vehicle?
    pendings
  end

  def check_vehicle_exist?
    result = !self.boarding_vehicles.present?
  end

  def check_type_vehicle_tracao_and_reboque?
    #Quando existir um reboque no embarque, tem que ter obrigatoriamente uma tracao
    if self.boarding_vehicles.present?
      if self.boarding_vehicles.count > 1 then
        if BoardingVehicle.joins(:vehicle).where(boarding_id: self.id, vehicles: {tipo: [Vehicle::Tipo::TRACAO, Vehicle::Tipo::REBOQUE]}).count == 2
          result = false
        else
          result = true
        end
      else
        if self.boarding_vehicles.first.vehicle.tipo == Vehicle::Tipo::TRACAO_BAU
          result = false
        else
          result = true
        end
      end
    end
  end

  def check_annt_exipired_vehicle_first?
    if self.boarding_vehicles.present?
      antt_vehicle = AnttsVehicles.where(vehicle_id: self.boarding_vehicles.order(:id).first.vehicle_id).first
      if antt_vehicle.present?
        result = Date.current > antt_vehicle.antt.date_expiration
      else
        result = false
      end
    else
      result = false
    end
  end

  def check_annt_exipired_vehicle_second?
    if self.boarding_vehicles.count > 1
      antt_vehicle = AnttsVehicles.where(vehicle_id: self.boarding_vehicles.order(:id).second.vehicle_id).first
      if antt_vehicle.present?
        result = Date.current > antt_vehicle.antt.date_expiration
      else
        result = false
      end
    else
      result = false
    end
  end

  def check_annt_exist_vehicle_first?
    if self.boarding_vehicles.present?
      result = !AnttsVehicles.where(vehicle_id: self.boarding_vehicles.order(:id).first.vehicle_id).present?
    else
      false
    end
  end

  def check_annt_exist_vehicle_second?
    if self.boarding_vehicles.count > 1
      result = !AnttsVehicles.where(vehicle_id: self.boarding_vehicles.order(:id).second.vehicle_id).present?
    else
      false
    end
  end


  def capacity_exceeded_vehicle?
    self.nfe_keys.sum(:qtde_pallet).to_f > self.capacidade_paletes.to_f
  end

  def nfe_dae_pending?
    positivo = false
    self.boarding_items.order(:delivery_number).each do |item|
      item.ordem_service.nfe_keys.each do |nfe|
        positivo = nfe.dae_pending?
        return true if positivo == true
      end
    end
    positivo
  end

  def get_dae_pending
    array = []
    self.boarding_items.order(:delivery_number).each do |item|
      item.ordem_service.nfe_keys.each do |nfe|
        array.append(nfe.nfe)
      end
    end
    array
  end

  def ordem_service_pending?
    positivo = false
    self.boarding_items.order(:delivery_number).each do |item|
      return false if item.ordem_service.type_direct_charge?
      positivo = item.ordem_service.input_control.present? ? item.ordem_service.input_control.status_open_and_finish_typing_and_discharge? : true
      return true if positivo == true
    end
    positivo
  end

  def get_dae_pending
    array = []
    self.boarding_items.order(:delivery_number).each do |item|
      if item.ordem_service.input_control.status_open_and_finish_typing_and_discharge?
        array.append(item.ordem_service.id)
      end
    end
    array
  end

  def close(ordem_service_id)
    boarding = Boarding.find(boarding_id)
    boarding.errors.add("Boarding", "DEPRECATED function. Please use the class confirmed function")
    # ActiveRecord::Base.transaction do
    #   OrdemService.where(id: ordem_service_id).update_all(
    #                                                   carrier_id: self.carrier_id,
    #                                                date_shipping: self.date_boarding,
    #                                                       status: OrdemService::TipoStatus::EMBARCADO)
    #   OrdemServiceLogistic.where(ordem_service_id: ordem_service_id).update_all(delivery_driver_id: self.driver_id)
    #   Boarding.where(id: self.id).update_all(status: Boarding::TipoStatus::EMBARCADO) if self.check_status_ordem_service?
    # end
  end

  def self.confirmed(boarding_id)
    boarding = Boarding.find(boarding_id)
    checkin = Checkin.the_day.input.where(driver_cpf: boarding.driver.cpf).first
    ActiveRecord::Base.transaction do
      # OrdemService.where(id: ordem_service_id).update_all(
      #                                                 carrier_id: self.carrier_id,
      #                                              date_shipping: self.date_boarding,
      #                                                     status: OrdemService::TipoStatus::EMBARCADO)
      # OrdemServiceLogistic.where(ordem_service_id: ordem_service_id).update_all(delivery_driver_id: self.driver_id)

      Boarding.where(id: boarding.id).update_all(finish_time_boarding: Time.current, status: Boarding::TipoStatus::EMBARCADO)
      boarding.boarding_items.each do |item|
        OrdemService.where(id: item.ordem_service_id).update_all(carrier_id: boarding.carrier_id,  date_shipping: Date.current, status: OrdemService::TipoStatus::EMBARCADO)
        OrdemServiceLogistic.where(ordem_service_id: item.ordem_service_id).update_all(delivery_driver_id: boarding.driver_id)
      end
      Checkin.create!( driver_cpf: boarding.driver.cpf,
                     driver_name: boarding.driver.nome.upcase,
                  operation_type: :boarding,
                    operation_id: boarding_id,
                     place_horse: checkin.place_horse,
                    place_cart_1: checkin.place_cart_1,
                    place_cart_2: checkin.place_cart_2,
                            door: checkin.door,
                          status: :finish)
      #BoardingMailer.notification_confirmed(ordem_service).deliver! if ordem_service.input_control.present?
    end
  end

  def self.start(boarding_id)
    boarding = Boarding.find(boarding_id)
    checkin = Checkin.the_day.input.where(driver_cpf: boarding.driver.cpf).first
    ActiveRecord::Base.transaction do
      Checkin.where(id: checkin.id).update_all(operation_id: boarding_id)
      Checkin.create!( driver_cpf: boarding.driver.cpf,
                     driver_name: boarding.driver.nome.upcase,
                  operation_type: :boarding,
                    operation_id: boarding_id,
                     place_horse: checkin.place_horse,
                    place_cart_1: checkin.place_cart_1,
                    place_cart_2: checkin.place_cart_2,
                            door: checkin.door,
                          status: :start)
      Boarding.where(id: boarding_id).update_all(start_time_boarding: Time.current, status: Boarding::TipoStatus::INICIADO)
    end
  end

  # def self.checkin(boarding_id)
  #   ActiveRecord::Base.transaction do
  #     Boarding.where(id: boarding_id).update_all(driver_checkin: true, driver_checkin_time: Time.current)
  #   end
  # end

  def self.checkin(boarding_id)
    boarding = Boarding.find(boarding_id)
    ActiveRecord::Base.transaction do
      Checkin.the_day.input.where(driver_cpf: boarding.driver.cpf).update_all(operation_id: boarding.id)
    end
  end

  def self.cancel(boarding_id)
    hash_ids = Boarding.ordem_services_ids(boarding_id)
    ActiveRecord::Base.transaction do
      #  OBS: quando cancelar o embarque, verificar a possibilidade de retirar a associacao da os no embarque
      OrdemService.where(id: hash_ids).update_all(status: OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
      Boarding.where(id: self.id).update_all(status: Boarding::TipoStatus::CANCELADO)
    end
  end

  def self.restart(boarding_id)
    hash_ids = Boarding.ordem_services_ids(boarding_id)
    ActiveRecord::Base.transaction do
      OrdemService.where(id: hash_ids).update_all(status: OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
      Boarding.where(id: boarding_id).update_all(status: Boarding::TipoStatus::ABERTO, place: nil, qtde_pallets_shipped: nil, team: nil, hangar: nil, dock: nil, start_time_boarding: nil, finish_time_boarding: nil)
    end
  end

  def peso_bruto
    boarding_items.joins(:ordem_service).sum("ordem_services.peso")
  end

  def volume_total(nfe_keys=nil)
    if nfe_keys.nil?
      boarding_items.joins(:ordem_service).sum("ordem_services.qtde_volume")
    else
      nfe_keys = self.comments.last.observation.gsub(" ","").gsub('[','').gsub(']','').split(',')
      self.nfe_keys.where(nfe: nfe_keys).sum("nfe_keys.volume")
    end
  end

  def valor_total
    #valor_ordem_service
    soma = 0
    self.boarding_items.each do |item|
      soma += item.ordem_service.valor_ordem_service
    end
    soma
  end

  def valor_nota_fiscal
    soma = 0
    self.boarding_items.each do |item|
      soma += item.ordem_service.valor_nota_fiscal
    end
    soma
  end

  def capacidade_paletes
    soma = 0
    self.boarding_vehicles.each do |item|
      soma += item.vehicle.qtde_paletes.blank? ? ZERO : item.vehicle.qtde_paletes
    end
    soma
  end

  def weight_exceeds_vehicle_capacity?
    self.peso_bruto.to_f > vehicle_weight_capacity
  end

  def vehicle_weight_capacity
    #vehicle = vehicle_reboque
    vehicles_capacity = self.boarding_vehicles.joins(:vehicle).sum("vehicles.capacity")
    # result = vehicle.nil? ? 0.00 : vehicle.capacity.to_f
    # result
  end

  # def vehicle_reboque
  #   vehicle_temp = self.boarding_vehicles.joins(:vehicle).where("vehicles.tipo = ? ", Vehicle::Tipo::REBOQUE).first
  #   vehicle_temp.nil? ? nil : Vehicle.find(vehicle_temp.vehicle_id)
  # end

  def qtde_palets
    soma = 0
    self.boarding_items.each do |item|
      soma += item.ordem_service.qtde_palets.blank? ? ZERO : item.ordem_service.qtde_palets
    end
    soma
  end

  def qtde_cte
    soma = 0
    self.boarding_items.each do |item|
      soma += item.ordem_service.qtde_cte
    end
    soma
  end

  def qtde_nfe
    soma = 0
    self.boarding_items.each do |item|
      soma += item.ordem_service.qtde_nfe
    end
    soma
  end

  def get_number_nfe
    nfes = []
    self.nfe_keys.each do |n|
      nfes << n.nfe
    end
    nfes
  end

  def qtde_entregas
    number = self.boarding_items.group('delivery_number').having('delivery_number > 0').count
    number.count
  end

  def ordem_services_ids
    get_ordem_services_ids
  end

  def self.ordem_services_ids(boarding)
    hash_ids = []
    boarding_other = Boarding.find(boarding.id)
    boarding_other.boarding_items.each do |item|
      hash_ids << item.ordem_service_id
    end
    hash_ids
  end

  def get_cities
    cities = []
    self.boarding_items.each do |item|
      cities << item.ordem_service.client.cidade
    end
    cities
  end

  def items_select_clients
    clients = []
    nfes_number = self.comments.last.observation.gsub(" ","").gsub('[','').gsub(']','').split(',')
    self.nfe_keys.where(nfe: nfes_number).each do |item|
      clients << item.ordem_service.client.nome
    end
    clients
  end

  def feed
    Comment.where("comment_type = ? and comment_id = ?", "Boarding", self.id)
  end

  def type_and_place_vehicles
    result = []
    self.boarding_vehicles.each do |item|
      result << item.vehicle.type_and_place
    end
    result
  end

  def places
    result = []
    self.boarding_vehicles.each do |item|
      result << item.vehicle.placa
    end
    result
  end

  def vehicle_tracao
    vehicle_temp = self.boarding_vehicles.joins(:vehicle).where("vehicles.tipo = ? ", Vehicle::Tipo::TRACAO).first
    vehicle_temp.nil? ? nil : Vehicle.find(vehicle_temp.vehicle_id)
  end

  def vehicle_reboque
    vehicle_temp = self.boarding_vehicles.joins(:vehicle).where("vehicles.tipo = ? ", Vehicle::Tipo::REBOQUE).first
    vehicle_temp.nil? ? nil : Vehicle.find(vehicle_temp.vehicle_id)
  end

  def requisition?(options={})
    #Atualizar qtde pallets boarding
    #fazer lancamento de debito para L7 Logistica ou Transportadora
    #Fazer lancamento de crédito para o motorista e ou responsavel
    equipament = ControlPalletInternal.get_equipament(options[:equipament])
    begin
      ActiveRecord::Base.transaction do
        Boarding.where(id: self.id).update_all(qtde_boarding: options[:qtde])
        ControlPalletInternal.create!(type_account: ControlPalletInternal::TypeAccount::CARRIER,
                                    responsable_type: "Carrier",
                                      responsable_id: 11, #Padrao L7
                                      boarding_id: self.id,
                                      equipament: options[:equipament],
                                      type_launche: ControlPalletInternal::CreditDebit::DEBIT,
                                      date_launche: Date.current,
                                      qtde: options[:qtde],
                                      historic: "SAIDA DE #{equipament.upcase} EMBARQUE No: #{self.id}"
                                    )
        ControlPalletInternal.create!(type_account: ControlPalletInternal::TypeAccount::DRIVER,
                                      responsable_type: "Driver",
                                      responsable_id: self.driver_id,
                                      boarding_id: self.id,
                                      equipament: options[:equipament],
                                      type_launche: ControlPalletInternal::CreditDebit::CREDIT,
                                      date_launche: Date.current,
                                      qtde: options[:qtde],
                                      historic: "ENTRADA DE #{equipament.upcase} EMBARQUE No: #{self.id}"
                                    )
        return true
      end
      rescue Exception => e
        puts e.message
        self.errors.add(:boarding, e.message)
        return false
    end
  end

  def self.driver_not_information
    conf = ConfigSystem.where(config_key: 'DRIVER_DEFAULT').first
    conf.config_value.to_i
  end

  def self.carrier_not_information
    conf = ConfigSystem.where(config_key: 'CARRIER_DEFAULT').first
    conf.config_value.to_i
  end

  def driver_checkin?
    Checkin.the_day.input.where(driver_cpf: self.driver.cpf).present?
  end

  def total_discharge_payment
    value = BigDecimal.new(0)
    self.boarding_items.each do |item|
      #puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #{item.ordem_service.discharge_payments.sum(:price)}"
      value += item.ordem_service.discharge_payments.sum(:price)
    end
    value
  end

  def observation_discharge_payment
    # Adicionar OS/Cliente/ValorDescarga
    line = Array.new
    # line.push("PAGAMENTO DE DESCARGA - 1;")
    # line.push("PAGAMENTO DE DESCARGA - 2;")
    # line.push("PAGAMENTO DE DESCARGA - 3;")
    #puts line.compact.join("\n")
    self.boarding_items.each do |item|
      line.push("O.S. #{item.ordem_service_id}, Cliente: #{item.ordem_service.client.nome}, Valor: #{item.ordem_service.discharge_payments.sum(:price)};")
    end
    line.push("NF-e: #{self.nfe_keys.pluck(:nfe)}")
    line
  end

  def check_all_ordem_service_have_payment_discharge?
    positivo = true
    self.boarding_items.each do |item|
      #byebug
      positivo = item.ordem_service.discharge_payments.present?
      if positivo == false
        return false
      end
    end
    positivo
  end

  private

    def get_ordem_services_ids
      hash_ids = []
      boarding = Boarding.find(self.id)
      boarding.boarding_items.each do |item|
        hash_ids << item.ordem_service_id
      end
      hash_ids
    end

end
