module AccountPayablesHelper
  
  def sub_center(cost_center)
    SubCostCenter.where("cost_center_id = ?", cost_center)
  end

end