class CreateInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :inventories do |t|
      t.references :ordem_service, index: true
      t.string :descricao, limit: 50, null: false
      t.integer :qtde, null: false
      t.string :estado, limit: 30
      t.decimal :valor, precision: 10, scale: 2

      t.timestamps
    end
  end
end
