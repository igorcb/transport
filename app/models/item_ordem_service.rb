class ItemOrdemService < ActiveRecord::Base
  belongs_to :ordem_service
  belongs_to :product
end
