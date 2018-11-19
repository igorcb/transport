class AddMarginLucreToClientTablePrice < ActiveRecord::Migration[5.0]
  def change
    add_column :client_table_prices, :margin_lucre, :decimal, precision: 10, scale: 2, default: 0
  end
end
