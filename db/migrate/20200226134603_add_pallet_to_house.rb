class AddPalletToHouse < ActiveRecord::Migration[5.1]
  def change
    add_reference :houses, :palletizing_pallet, foreign_key: true
  end
end
