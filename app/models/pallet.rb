class Pallet < ActiveRecord::Base
  validates :client_id, presence: true
  validates :data_informada, presence: true
  validates :qtde_informada, presence: true, numericality: { greater_than: 0 }
  validates :qtde, presence: true, numericality: { greater_than: 0 }, if: :data_agendamento?
  belongs_to :client
  before_create :set_status

  def set_status
  	self.status = 0
  end

  def status_name
    case self.status
	    when 0 then "Aberto"
	    when 1 then "Agendado"
	    when 2 then "OS Criada"
    end
  end

  def create_os(*args)

    ActiveRecord::Base.transaction do
      os = OrdemService.create!(tipo: OrdemService::TipoOS::PALETE,
                               driver_id: args[0],
                               client_id: self.client_id,
                               data: self.data_agendamento,
                               placa: args[1],
                               estado: args[2],
                               cidade: args[3]
                               )
      valor = self.qtde * 9
      OrdemServiceTypeService.create!(ordem_service_id: os.id, 
                                      type_service_id: 22, 
                                      qtde: qtde,
                                      valor: valor
                                      )
      self.status = 2
      self.save!      
    end
  end

end

