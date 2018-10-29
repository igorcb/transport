class CreateOrdemServiceAirs < ActiveRecord::Migration[5.0]
  def change
    create_table :ordem_service_airs do |t|
      t.references :ordem_service, index: true
      t.integer :source_stretch_id, index: true
      t.integer :target_stretch_id, index: true
      t.integer :target_agent_id, index: true
      t.integer :airline_carrier_id, index: true
      t.string :solicitante
      t.string :awb, limit: 20
      t.string :voo, limit: 10
      t.date :previsao
      t.integer :tipo_frete
      t.integer :qtde_volume
      t.decimal :peso, precision: 10, scale: 2
      t.decimal :valor_nf, precision: 10, scale: 2
      t.decimal :total_cubagem, precision: 10, scale: 2
      t.decimal :tarifa_companhia, precision: 10, scale: 2
      t.decimal :valor_total, precision: 10, scale: 2

      t.timestamps
    end
  end
end
