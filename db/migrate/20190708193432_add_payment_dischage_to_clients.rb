class AddPaymentDischageToClients < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :payment_discharge, :boolean, default: true
  end
end
