class AddDirectChargeIdToAccountReceivables < ActiveRecord::Migration
  def change
    add_reference :account_receivables, :direct_charge, index: true
  end
end
