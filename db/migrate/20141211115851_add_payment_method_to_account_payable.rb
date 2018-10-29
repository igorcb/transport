class AddPaymentMethodToAccountPayable < ActiveRecord::Migration[5.0]
  def change
    add_reference :account_payables, :payment_method, index: true
    AccountPayable.update_all(payment_method_id: 2)
  end
end
