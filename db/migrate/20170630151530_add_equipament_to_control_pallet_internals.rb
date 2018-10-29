class AddEquipamentToControlPalletInternals < ActiveRecord::Migration[5.0]
  def change
    add_column :control_pallet_internals, :equipament, :integer
  end
end
