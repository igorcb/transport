class AddPaymentMethodToAccountPayable < ActiveRecord::Migration
  def change
    add_reference :account_payables, :payment_method, index: true
    AccountPayable.update_all(payment_method_id: 2)
  end
end
