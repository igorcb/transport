class AddSubCostCenterThreeToCash < ActiveRecord::Migration[5.0]
  def change
    add_reference :cashes, :sub_cost_center_three, index: true
  end
end
