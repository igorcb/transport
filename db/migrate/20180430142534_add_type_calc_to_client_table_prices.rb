class AddTypeCalcToClientTablePrices < ActiveRecord::Migration[5.0]
  def change
    add_column :client_table_prices, :type_calc, :integer, default: 0
  end
end
