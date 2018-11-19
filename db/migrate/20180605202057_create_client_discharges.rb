class CreateClientDischarges < ActiveRecord::Migration[5.0]
  def change
    create_table :client_discharges do |t|
      t.references :client
      t.references :client_source, references: :clients
      t.integer :type_unit
      t.integer :type_charge
      t.integer :type_calc
      t.decimal :price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
