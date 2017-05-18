class CreateItemInputControls < ActiveRecord::Migration
  def change
    create_table :item_input_controls do |t|
      t.references :input_control, index: true
      t.references :product, index: true
      t.string :number_nfe
      t.decimal :qtde
      t.decimal :qtde_trib
      t.string :unid_medida
      t.decimal :valor, precision: 20, scale: 4
      t.decimal :valor_unitario, precision: 20, scale: 4
      t.decimal :valor_unitario_comer, precision: 20, scale: 4

      t.timestamps
    end
  end
end
