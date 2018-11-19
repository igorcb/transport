class AddCashAccountToCash < ActiveRecord::Migration[5.0]
  def change
    add_reference :cashes, :cash_account, index: true
  end
end
