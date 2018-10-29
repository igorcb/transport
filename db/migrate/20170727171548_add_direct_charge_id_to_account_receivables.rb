class AddDirectChargeIdToAccountReceivables < ActiveRecord::Migration[5.0]
  def change
    add_reference :account_receivables, :direct_charge, index: true
  end
end
