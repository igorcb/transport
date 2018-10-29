class AddAccountPayableToCash < ActiveRecord::Migration[5.0]
  def change
    add_reference :cashes, :account_payable, index: true
  end
end
