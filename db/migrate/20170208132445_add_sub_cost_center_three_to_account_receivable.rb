class AddSubCostCenterThreeToAccountReceivable < ActiveRecord::Migration
  def change
    add_reference :account_receivables, :sub_cost_center_three, index: true
  end
end
