class AddPaymentMethodToAccountReceivable < ActiveRecord::Migration
  def change
    add_reference :account_receivables, :payment_method, index: true
  end
end
