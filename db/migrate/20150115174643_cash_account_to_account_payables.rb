class CashAccountToAccountPayables < ActiveRecord::Migration
  def change
  	 add_column :account_payables, :cash_account_id, :integer
  end
end
