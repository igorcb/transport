class AddSubCostCenterThreeToAccountPayables < ActiveRecord::Migration
  def change
    add_reference :account_payables, :sub_cost_center_three, index: true
  end
end
