class CreateControlPalletInternals < ActiveRecord::Migration[5.0]
  def change
    create_table :control_pallet_internals do |t|
      t.string :responsable_type
      t.integer :responsable_id
      t.integer :type_launche
      t.date :date_launche
      t.integer :qtde
      t.string :historic
      t.text :observation

      t.timestamps
    end
  end
end
