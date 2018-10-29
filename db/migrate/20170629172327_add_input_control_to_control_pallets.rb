class AddInputControlToControlPallets < ActiveRecord::Migration[5.0]
  def change
    add_reference :control_pallets, :input_control, index: true
  end
end
