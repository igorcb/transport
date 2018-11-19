class AddCarrierToControlPallets < ActiveRecord::Migration[5.0]
  def change
    add_reference :control_pallets, :carrier, index: true
  end
end
