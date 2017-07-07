class AddPesoLiquidoToNfeXmls < ActiveRecord::Migration
  def change
    add_column :nfe_xmls, :peso_liquido, :decimal, precision: 10, scale: 3
  end
end
