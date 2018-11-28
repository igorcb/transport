class BudgetItem < ActiveRecord::Base
  belongs_to :budget, required: false
  belongs_to :product, required: false

  def cubagem_total
  	qtde * self.product.cubagem
  end
end
