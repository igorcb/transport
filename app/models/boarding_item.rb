class BoardingItem < ActiveRecord::Base
 	include RankedModel
  ranks :row_order	

  validates :boarding_id, presence: true
  validates :ordem_service_id, presence: true
  validates :delivery_number, presence: true

  belongs_to :boarding
  belongs_to :ordem_service

end
