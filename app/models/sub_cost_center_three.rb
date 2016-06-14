class SubCostCenterThree < ActiveRecord::Base
  belongs_to :cost_center
  belongs_to :sub_cost_center
end
