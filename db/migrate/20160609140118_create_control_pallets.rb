class CreateControlPallets < ActiveRecord::Migration
  def change
    create_table :control_pallets do |t|
      t.references :client, index: true
      t.date :data
      t.integer :qte
      t.integer :tipo
      t.string :historico

      t.timestamps
    end
  end
end
