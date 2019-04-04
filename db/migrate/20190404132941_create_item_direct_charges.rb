class CreateItemDirectCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :item_direct_charges do |t|
      t.references :direct_charge, index: true
      t.references :product, index: true
      t.references :nfe_xml, index: true
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
