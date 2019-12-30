class CreatePalletizingPallets < ActiveRecord::Migration[5.1]
  def change
    create_table :palletizing_pallets do |t|
      t.string :number
      t.integer :type_pallet
      t.references :palletizing, foreign_key: true
      
      t.timestamps
    end
  end
end
