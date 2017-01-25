class AddCashAccountToCash < ActiveRecord::Migration
  def change
    add_reference :cashes, :cash_account, index: true
  end
end
