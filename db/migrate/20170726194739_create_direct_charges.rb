class CreateDirectCharges < ActiveRecord::Migration
  def change
    create_table :direct_charges do |t|
      t.references :carrier, index: true
      t.references :driver, index: true
      t.string :place, limit: 10, null: false
      t.string :place_cart, limit: 10
      t.string :place_cart_2, limit: 10
      t.date :date_charge
      t.boolean :palletized, default: false
      t.integer :quantity_pallets
      t.boolean :charge_discharge, default: true
      t.decimal :weight, precision: 10, scale: 3
      t.decimal :volume, precision: 10, scale: 3
      t.decimal :value_ton, precision: 20, scale: 4
      t.decimal :value_kg, precision: 20, scale: 4
      t.decimal :value_total, precision: 20, scale: 4
      t.integer :status, default: 0
      t.date    :date_closing
      t.text    :observation
      t.string  :source_state
      t.string  :source_city
      t.string  :target_state
      t.string  :target_city
      t.references :user, index: true

      t.timestamps
    end
  end
end