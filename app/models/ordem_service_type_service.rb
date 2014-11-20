class OrdemServiceTypeService < ActiveRecord::Base
  #validates :ordem_service, presence: true
  validates :type_service, presence: true
  validates :valor, presence: true, numericality: { greater_than: 0 }

  belongs_to :ordem_service
  belongs_to :type_service
end
