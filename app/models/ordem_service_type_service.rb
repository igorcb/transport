class OrdemServiceTypeService < ActiveRecord::Base
  #validates :ordem_service, presence: true
  validates :type_service, presence: true
  validates :valor, presence: true, numericality: { greater_than: 0 }

  belongs_to :ordem_service
  belongs_to :type_service
  has_one :account_payable

  scope :open, -> { joins(:type_service).where(status: [0, 1]).order('type_services.descricao') }
  scope :close, -> { joins(:type_service).where(status: 2).order('type_services.descricao') }

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

end

