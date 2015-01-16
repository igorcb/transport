class AddCashAccountToLowerAccountPayable < ActiveRecord::Migration
  def change
    add_reference :lower_account_payables, :cash_account, index: true
  end
end
