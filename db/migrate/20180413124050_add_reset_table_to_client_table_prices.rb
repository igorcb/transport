class AddResetTableToClientTablePrices < ActiveRecord::Migration
  def change
    add_column :client_table_prices, :reset, :boolean
  end
end
