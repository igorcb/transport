class AddSubCostCenterThreeToAccountPayables < ActiveRecord::Migration[5.0]
  def change
    add_reference :account_payables, :sub_cost_center_three, index: true
  end
end
