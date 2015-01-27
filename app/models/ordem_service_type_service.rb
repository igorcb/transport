class OrdemServiceTypeService < ActiveRecord::Base
  #validates :ordem_service, presence: true
  validates :type_service, presence: true
  validates :valor, presence: true, numericality: { greater_than: 0 }

  belongs_to :ordem_service
  belongs_to :type_service
  has_one :account_payable

  scope :both, -> { joins(:type_service, :ordem_service).order('ordem_services.data desc') }
  scope :open, -> { joins(:type_service, :ordem_service).where(status: [0, 1]).order('ordem_services.data desc') }
  scope :close, -> { joins(:type_service, :ordem_service).where(status: 2).order('ordem_services.data desc') }
#  scope :everyday, ->(date) { both.where("ordem_services.data = ?", date ) }

  module TipoStatus
    ABERTO = 0
    PENDENTE = 1
    PAGO = 2
  end

  def status_name
    case self.status
      when 0  then "Aberto"
      when 1  then "Pendente"
      when 2  then "Pago"
    else "Nao Definido"
    end
  end 

  def opened?
    self.status == TipoStatus::ABERTO
  end

  # def self.locate(query)
  #   where("con_email ilike ?", "%#{query}%" )
  # end  

  def self.ransackable_attributes(auth_object = nil)
    ['status' ]
  end

  def self.send_report
    #puts ">>>>>>>>>>>>>>>>>>> model: vai enviar e-mail"
    #OrdemServiceTypeService.report_mailer.deliver_now
    #Cobranca.notificar_financeiro_f13(cobranca) 
  end

end

