class ItemOrdemService < ActiveRecord::Base
  belongs_to :ordem_service, required: false
  belongs_to :product, required: false

  def calculation_cubing
  	product.calculation_cubing.to_f * qtde
  end
end
