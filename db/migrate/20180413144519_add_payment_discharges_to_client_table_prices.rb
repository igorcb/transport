class AddPaymentDischargesToClientTablePrices < ActiveRecord::Migration
  def change
    add_column :client_table_prices, :payment_discharges, :decimal, precision: 10, scale: 2, default: 0
  end
end
