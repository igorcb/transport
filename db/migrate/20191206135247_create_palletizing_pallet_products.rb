class CreatePalletizingPalletProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :palletizing_pallet_products do |t|
      t.references :palletizing_pallet, foreign_key: true
      t.references :product, foreign_key: true
      t.references :nfe_xml, foreign_key: true
      t.integer :qtde

      t.timestamps
    end
  end
end
