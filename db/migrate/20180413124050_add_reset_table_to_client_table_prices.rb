class AddResetTableToClientTablePrices < ActiveRecord::Migration[5.0]
  def change
    add_column :client_table_prices, :reset, :boolean
  end
end
