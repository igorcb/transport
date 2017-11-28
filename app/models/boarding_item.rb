class BoardingItem < ActiveRecord::Base
 	include RankedModel
  ranks :row_order	

  validates :boarding_id, presence: true
  validates :ordem_service_id, presence: true, uniqueness: true
  validates :delivery_number, presence: true

  belongs_to :boarding
  belongs_to :ordem_service

  has_many :item_ordem_services, :through => :ordem_service
  has_many :products, :through => :item_ordem_services

end
