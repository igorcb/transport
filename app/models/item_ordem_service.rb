class ItemOrdemService < ActiveRecord::Base
  belongs_to :ordem_service
  belongs_to :product

  def calculation_cubing
  	product.calculation_cubing * qtde
  end
end
