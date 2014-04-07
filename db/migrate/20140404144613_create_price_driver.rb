class CreatePriceDrivers < ActiveRecord::Migration
  def change
    create_table :price_drivers do |t|
      t.integer :uf_tipo, null: false
      t.integer :tipo, null: false
      t.decimal :valor, precision: 10, scale: 2, null: false
      t.references :driver, index: true
      t.timestamps
    end

    add_index :price_drivers, [:driver_id, :uf_tipo, :tipo], unique: true
  end
end
