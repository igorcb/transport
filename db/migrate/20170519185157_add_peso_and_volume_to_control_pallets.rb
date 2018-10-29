class AddPesoAndVolumeToControlPallets < ActiveRecord::Migration[5.0]
  def change
    add_column :control_pallets, :peso, :decimal, precision: 10, scale: 3
    add_column :control_pallets, :volume, :decimal, precision: 10, scale: 3
  end
end
