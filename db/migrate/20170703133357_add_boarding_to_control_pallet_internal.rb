class AddBoardingToControlPalletInternal < ActiveRecord::Migration[5.0]
  def change
    add_reference :control_pallet_internals, :boarding, index: true
  end
end
