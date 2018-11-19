class CreateVehicles < ActiveRecord::Migration[5.0]
  def change
    create_table :vehicles do |t|
      t.string :marca, limit: 20, null: false
      t.string :modelo, limit: 20, null: false
      t.integer :ano, null: false
      t.string :cor, limit: 20, null: false
      t.integer :tipo_veiculo, null: false
      t.string :municipio_emplacamento, limit: 100, null: false
      t.string :estado, limit: 2, null: false
      t.string :renavan, limit: 20, null: false
      t.string :chassi, limit: 20, null: false
      t.string :capacidade, null: false
      t.string :placa, limit: 8, null: false
      t.string :especie, limit: 20, null: false
      t.integer :numero_eixos, null: false
      t.integer :numero_loks, null: false
      t.boolean :grade, null: false
      t.boolean :cordas, null: false
      t.boolean :lonas, null: false
      t.boolean :capacitacao, null: false
      t.boolean :kit_quimico, null: false


      t.timestamps
    end
  end
end
