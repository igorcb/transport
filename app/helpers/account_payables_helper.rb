module AccountPayablesHelper
  
  def sub_center(cost_center)
    SubCostCenter.where("cost_center_id = ?", cost_center)
  end

  def type_account_select(type)
    case type
      when 0 then Supplier.order('nome')
      when 1 then Driver.order('nome')
      when 2 then Client.order('nome')
      when 3 then Employee.order('nome')
      when 4 then Carrier.order('nome')
    end  	
  end
end
