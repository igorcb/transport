class AddSubCostCenterThreeToCash < ActiveRecord::Migration
  def change
    add_reference :cashes, :sub_cost_center_three, index: true
  end
end
