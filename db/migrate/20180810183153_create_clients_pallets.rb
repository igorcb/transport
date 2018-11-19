class CreateClientsPallets < ActiveRecord::Migration[5.0]
  def change
    create_table :clients_pallets do |t|
      t.references :client, index: true
      t.references :product, index: true
      t.decimal :layer_pallet, :decimal, precision: 10, scale: 2

      t.timestamps
    end
  end
end
