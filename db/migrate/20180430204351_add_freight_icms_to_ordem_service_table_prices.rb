class AddFreightIcmsToOrdemServiceTablePrices < ActiveRecord::Migration
  def change
    add_column :ordem_service_table_prices, :freight_icms_value, :decimal, precision: 20, scale: 4, default: 0
    add_column :ordem_service_table_prices, :freight_icms_tax, :decimal, precision: 20, scale: 4, default: 0
  end
end