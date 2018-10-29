class CashAccountToAccountPayables < ActiveRecord::Migration[5.0]
  def change
  	 add_column :account_payables, :cash_account_id, :integer
  end
end
