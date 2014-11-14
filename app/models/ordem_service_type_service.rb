class OrdemServiceTypeService < ActiveRecord::Base
  validates :ordem_service_id, presence: true
  validates :type_service_id, presence: true
  validates :valor, presence: true

  belongs_to :ordem_service
  belongs_to :type_service
end
