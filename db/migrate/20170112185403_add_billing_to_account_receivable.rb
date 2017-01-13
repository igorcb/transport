class AddBillingToAccountReceivable < ActiveRecord::Migration
  def change
    add_reference :account_receivables, :billing, index: true
  end
end
