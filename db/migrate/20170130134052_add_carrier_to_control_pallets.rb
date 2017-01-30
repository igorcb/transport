class AddCarrierToControlPallets < ActiveRecord::Migration
  def change
    add_reference :control_pallets, :carrier, index: true
  end
end
