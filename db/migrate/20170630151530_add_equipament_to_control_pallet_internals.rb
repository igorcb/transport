class AddEquipamentToControlPalletInternals < ActiveRecord::Migration
  def change
    add_column :control_pallet_internals, :equipament, :integer
  end
end
