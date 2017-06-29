class AddInputControlToControlPallets < ActiveRecord::Migration
  def change
    add_reference :control_pallets, :input_control, index: true
  end
end
