class CreateOrdemServiceLogistics < ActiveRecord::Migration[5.0]
  def change
    create_table :ordem_service_logistics do |t|
      t.references :ordem_service, index: true
      t.references :driver, index: true
      t.integer :delivery_driver_id, index: true
      t.string  :placa, limit: 10, null: false
      # t.string  :cte, limit: 20, null: false
      # t.string  :danfe_cte, :string, limit: 44
      t.string  :senha_sefaz, limit: 15
      t.decimal :qtde_volume, :decimal, precision: 10, scale: 2
      t.decimal :peso, :decimal, precision: 10, scale: 2

      t.timestamps
    end
  end

end
