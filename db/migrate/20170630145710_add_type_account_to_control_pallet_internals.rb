class AddTypeAccountToControlPalletInternals < ActiveRecord::Migration
  def change
    add_column :control_pallet_internals, :type_account, :integer
  end
end
