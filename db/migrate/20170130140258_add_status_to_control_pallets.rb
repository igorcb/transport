class AddStatusToControlPallets < ActiveRecord::Migration[5.0]
  def change
    add_column :control_pallets, :status, :integer, default: 0
  end
end
