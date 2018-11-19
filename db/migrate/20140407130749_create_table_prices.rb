class CreateTablePrices < ActiveRecord::Migration[5.0]
  def change
    create_table :table_prices do |t|
      t.integer :uf_tipo, null: false
      t.integer :tipo, null: false
      t.decimal :valor, precision: 10, scale: 2, null: false
      t.integer :table_price_id
      t.string :table_price_type

      t.timestamps
    end

    #add_index :table_prices, [:uf_tipo, :tipo, :table_type, :table_id], unique: true
  end
end
