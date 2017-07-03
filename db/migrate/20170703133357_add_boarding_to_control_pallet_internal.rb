class AddBoardingToControlPalletInternal < ActiveRecord::Migration
  def change
    add_reference :control_pallet_internals, :boarding, index: true
  end
end
