class Budget < ActiveRecord::Base
  has_many :budget_items, dependent: :destroy
  accepts_nested_attributes_for :budget_items, allow_destroy: true, reject_if: :all_blank  	

  def cubagem_total
  	total = 0.00
  	self.budget_items.each do |item|
      total = total + item.cubagem_total
    end
    total
  end
end
