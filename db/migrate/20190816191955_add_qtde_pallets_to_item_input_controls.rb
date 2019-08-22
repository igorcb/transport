class AddQtdePalletsToItemInputControls < ActiveRecord::Migration[5.1]
  def change
    add_column :item_input_controls, :qtde_pallet, :integer
  end
end
