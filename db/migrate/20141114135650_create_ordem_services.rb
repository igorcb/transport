class CreateOrdemServices < ActiveRecord::Migration[5.0]
  def change
    create_table :ordem_services do |t|
      t.references :driver, index: true
      t.references :client, index: true
      t.date :data, null: false, index: true
      t.string :placa, limit: 10, null: false
      t.string :estado, limit: 2, null: false
      t.string :cidade, limit: 100, null: false
      t.string :cte, limit: 20, null: false
      t.string :danfe_cte, :string, limit: 45
      t.string :nfe, limit: 20, null: false
      t.string :danfe_nfe, limit: 45, null: false
      t.decimal :valor_receita, precision: 10, scale: 2, null: false
      t.decimal :valor_despesas, precision: 10, scale: 2, null: false
      t.decimal :valor_liquido, precision: 10, scale: 2, null: false
      t.text :observacao
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
