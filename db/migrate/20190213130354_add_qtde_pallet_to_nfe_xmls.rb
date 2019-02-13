class AddQtdePalletToNfeXmls < ActiveRecord::Migration[5.1]
  def change
    add_column :nfe_xmls, :qtde_pallet, :integer
  end
end
