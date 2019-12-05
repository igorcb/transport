class CreatePalletizingPallets < ActiveRecord::Migration[5.1]
  def change
    create_table :palletizing_pallets do |t|
      t.integer :number
      t.integer :type
      t.references :palletizing, foreign_key: true
      t.integer :qtde_sku
      t.integer :qtde_items

      t.timestamps
    end
  end
end
