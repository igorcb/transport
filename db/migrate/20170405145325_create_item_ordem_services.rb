class CreateItemOrdemServices < ActiveRecord::Migration
  def change
    create_table :item_ordem_services do |t|
      t.references :ordem_service, index: true
      t.references :product, index: true
      t.string :number
      t.decimal :qtde, precision: 10, scale: 4
      t.decimal :qtde_trib, precision: 20, scale: 4
      t.string :unid_medida
      t.decimal :valor, precision: 20, scale: 4
      t.decimal :valor_unitario_comer, precision: 20, scale: 10
      t.decimal :valor_unitario, precision: 20, scale: 10

      t.timestamps
    end
  end
end
