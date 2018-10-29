class AddPaymentMethodToAccountReceivable < ActiveRecord::Migration[5.0]
  def change
    add_reference :account_receivables, :payment_method, index: true
  end
end
