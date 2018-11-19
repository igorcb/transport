class AddCashAccountToLowerAccountPayable < ActiveRecord::Migration[5.0]
  def change
    add_reference :lower_account_payables, :cash_account, index: true
  end
end
