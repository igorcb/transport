class OrdemServiceTypeService < ActiveRecord::Base
  #validates :ordem_service, presence: true
  validates :type_service, presence: true
  validates :valor, presence: true, numericality: { greater_than: 0 }

  belongs_to :ordem_service
  belongs_to :type_service

  scope :open, -> { joins(:type_service).where(status: 0).order('type_services.descricao') }
  scope :close, -> { joins(:type_service).where(status: 1).order('type_services.descricao') }

  module TipoStatus
    ABERTO = 0
    PAGO = 1
  end

  def status_name
    case self.status
      when 0  then "Aberto"
      when 1  then "Pago"
    else "Nao Definido"
    end
  end 

end
