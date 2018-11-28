class SubCostCenterThree < ActiveRecord::Base
	validates :descricao, presence: true, uniqueness: { scope: [:cost_center, :sub_cost_center] }

  belongs_to :cost_center, required: false
  belongs_to :sub_cost_center, required: false
end
