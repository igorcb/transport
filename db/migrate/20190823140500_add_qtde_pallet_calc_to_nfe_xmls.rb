class AddQtdePalletCalcToNfeXmls < ActiveRecord::Migration[5.1]
  def change
    add_column :nfe_xmls, :qtde_pallet_calc, :integer
  end
end
