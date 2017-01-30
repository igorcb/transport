class AddStatusToControlPallets < ActiveRecord::Migration
  def change
    add_column :control_pallets, :status, :integer, default: 0
  end
end
