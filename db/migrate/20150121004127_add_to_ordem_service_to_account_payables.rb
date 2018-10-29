class AddToOrdemServiceToAccountPayables < ActiveRecord::Migration[5.0]
  def change
    add_reference :account_payables, :ordem_service, index: true
    add_reference :account_payables, :ordem_service_type_service, index: true
  end
end
