class Inventory < ActiveRecord::Base
  validates :descricao, presence: true, length: { maximum: 100 } 
  validates :qtde, presence: true

  belongs_to :ordem_service
end
