class CreateClientTablePrices < ActiveRecord::Migration
  def change
    create_table :client_table_prices do |t|
      t.references :client, index: true
      t.references :type_service, index: true
      t.references :stretch_route, index: true
      t.decimal :freight_weight, precision: 10, scale: 2, default: 0
      t.decimal :freight_value, precision: 10, scale: 2, default: 0
      t.decimal :freight_volume, precision: 10, scale: 2, default: 0
      t.decimal :freight_dispatch, precision: 10, scale: 2, default: 0
      t.decimal :freight_toll, precision: 10, scale: 2, default: 0
      t.integer :freight_type_gris
      t.decimal :freight_gris, precision: 10, scale: 2, default: 0
      t.integer :freight_type_trt
      t.decimal :freight_trt, precision: 10, scale: 2, default: 0
      t.decimal :minimum_total_freight, precision: 10, scale: 2, default: 0
      t.decimal :minimum_weiht, precision: 10, scale: 2, default: 0
      t.decimal :minimum_value, precision: 10, scale: 2, default: 0
      t.decimal :minimum_gris, precision: 10, scale: 2, default: 0
      t.decimal :minimum_trt, precision: 10, scale: 2, default: 0
      t.decimal :minimum_weight_kg, precision: 10, scale: 2, default: 0
      t.integer :collection_delivery_incidence
      t.boolean :collection_delivery_ad_icms_value_frete
      t.boolean :collection_delivery_ad_value_minimum
      t.decimal :collection_delivery_icms_taxpayer, precision: 10, scale: 2, default: 0
      t.decimal :collection_delivery_non_taxpayer, precision: 10, scale: 2, default: 0
      t.decimal :collection_delivery_iss, precision: 10, scale: 2, default: 0
      t.integer :use_aliquot_consumer_last
      t.integer :validity_status
      t.date :validity_start
      t.date :validity_end
      t.decimal :secure_rate, precision: 10, scale: 2, default: 0
      t.decimal :secure_rate_filch, precision: 10, scale: 2, default: 0
      t.decimal :secure_rate_aggravated, precision: 10, scale: 2, default: 0

      t.timestamps
    end
  end
end
