class AddAccountPayablesToCurrentAccount < ActiveRecord::Migration[5.0]
  def change
    add_reference :current_accounts, :account_payable, index: true
  end
end
