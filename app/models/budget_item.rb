class BudgetItem < ActiveRecord::Base
  belongs_to :budget
  belongs_to :product

  def cubagem_total
  	qtde * self.product.cubagem
  end
end
