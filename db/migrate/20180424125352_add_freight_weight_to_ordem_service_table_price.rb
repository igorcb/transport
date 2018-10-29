class AddFreightWeightToOrdemServiceTablePrice < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_service_table_prices, :freight_weight_tax, :decimal, precision: 20, scale: 4, default: 0
    add_column :ordem_service_table_prices, :freight_weight_value, :decimal, precision: 20, scale: 4, default: 0
  end
end
