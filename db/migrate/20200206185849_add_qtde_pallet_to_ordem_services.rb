class AddQtdePalletToOrdemServices < ActiveRecord::Migration[5.1]
  def change
    add_column :ordem_services, :qtde_pallet, :integer
  end
end
