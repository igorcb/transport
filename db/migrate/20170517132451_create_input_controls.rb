class CreateInputControls < ActiveRecord::Migration
  def change
    create_table :input_controls do |t|
      t.references :carrier, index: true
      t.references :driver, index: true
      t.string :place, limit: 10, null: false
      t.string :place_cart, limit: 10
      t.string :place_cart_2, limit: 10
      t.date :date_entry
      t.time :time_entry
      t.date :date_receipt
      t.boolean :palletized
      t.integer :quantity_pallets
      t.decimal :weight, precision: 10, scale: 3
      t.decimal :volume, precision: 10, scale: 3
      t.decimal :value_ton, precision: 20, scale: 4
      t.decimal :value_kg, precision: 20, scale: 4
      t.decimal :value_total, precision: 20, scale: 4
      t.integer :status
      t.date    :date_closing
      t.text    :observation
      t.references :user, index: true

      t.timestamps
    end
  end
end
