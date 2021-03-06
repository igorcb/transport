class BoardingItem < ActiveRecord::Base
 	include RankedModel
  ranks :row_order

  validates :boarding_id, presence: true
  validates :ordem_service_id, presence: true, uniqueness: true
  validates :delivery_number, presence: true

  belongs_to :boarding, required: false
  belongs_to :ordem_service, required: false

  has_many :item_ordem_services, :through => :ordem_service
  has_many :products, :through => :item_ordem_services

  before_create :is_payment_of_dae

  def is_payment_of_dae
  	self.ordem_service.input_control
  end

  def input_control
  	ordem_service.input_control
  end

  def can_destroy_item?
    # (
    #   self.ordem_service.status == OrdemService::TipoStatus::ABERTO ||
    #   self.ordem_service.status == OrdemService::TipoStatus::AGUARDANDO_EMBARQUE ||
    #   !self.ordem_service.account_payables.present?
    # )
    if self.ordem_service.status == OrdemService::TipoStatus::ABERTO ||
       self.ordem_service.status == OrdemService::TipoStatus::AGUARDANDO_EMBARQUE ||
       self.ordem_service.account_payables.present?
      errors.add(:base, "You can not delete record with relationship")
      return false
    end
  end


end
