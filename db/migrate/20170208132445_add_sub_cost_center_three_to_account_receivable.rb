class AddSubCostCenterThreeToAccountReceivable < ActiveRecord::Migration[5.0]
  def change
    add_reference :account_receivables, :sub_cost_center_three, index: true
  end
end
