class AddUserToPalletizingPallets < ActiveRecord::Migration[5.1]
  def change
    add_reference :palletizing_pallets, :user
  end
end
