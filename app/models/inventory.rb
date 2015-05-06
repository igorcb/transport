class Inventory < ActiveRecord::Base
  validates :descricao, presence: true, length: { maximum: 100 } 
  validates :qtde, presence: true, numericality: { only_integer: true }
  validates :numero, presence: true, numericality: { only_integer: true }

  belongs_to :ordem_service
end
