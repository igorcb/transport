class AddAccountPayablesToCurrentAccount < ActiveRecord::Migration
  def change
    add_reference :current_accounts, :account_payable, index: true
  end
end
