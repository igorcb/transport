class AddTypeAccountToControlPalletInternals < ActiveRecord::Migration[5.0]
  def change
    add_column :control_pallet_internals, :type_account, :integer
  end
end
