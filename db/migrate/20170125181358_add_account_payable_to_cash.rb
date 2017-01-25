class AddAccountPayableToCash < ActiveRecord::Migration
  def change
    add_reference :cashes, :account_payable, index: true
  end
end
