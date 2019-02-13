class AddQtdePalletToNfeKeys < ActiveRecord::Migration[5.1]
  def change
    add_column :nfe_keys, :qtde_pallet, :integer
  end
end
