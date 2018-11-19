class AddBillingToAccountReceivable < ActiveRecord::Migration[5.0]
  def change
    add_reference :account_receivables, :billing, index: true
  end
end
