class AddTypeCalcToClientTablePrices < ActiveRecord::Migration
  def change
    add_column :client_table_prices, :type_calc, :integer, default: 0
  end
end
