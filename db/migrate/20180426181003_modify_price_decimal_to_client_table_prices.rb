class ModifyPriceDecimalToClientTablePrices < ActiveRecord::Migration
	def self.up
    change_column :client_table_prices, :freight_weight,                    :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :freight_value,                     :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :freight_volume,                    :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :freight_dispatch,                  :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :freight_toll,                      :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :freight_gris,                      :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :freight_trt,                       :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :minimum_total_freight,             :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :minimum_weiht,                     :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :minimum_value,                     :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :minimum_gris,                      :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :minimum_trt,                       :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :minimum_weight_kg,                 :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :collection_delivery_icms_taxpayer, :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :collection_delivery_non_taxpayer,  :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :collection_delivery_iss,           :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :secure_rate,                       :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :secure_rate_filch,                 :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :secure_rate_aggravated,            :decimal, precision: 10, scale: 4, default: 0
    change_column :client_table_prices, :margin_lucre,                      :decimal, precision: 10, scale: 4, default: 0  
  end

	def self.down
    change_column :client_table_prices, :freight_weight,                    :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :freight_value,                     :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :freight_volume,                    :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :freight_dispatch,                  :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :freight_toll,                      :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :freight_gris,                      :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :freight_trt,                       :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :minimum_total_freight,             :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :minimum_weiht,                     :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :minimum_value,                     :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :minimum_gris,                      :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :minimum_trt,                       :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :minimum_weight_kg,                 :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :collection_delivery_icms_taxpayer, :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :collection_delivery_non_taxpayer,  :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :collection_delivery_iss,           :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :secure_rate,                       :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :secure_rate_filch,                 :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :secure_rate_aggravated,            :decimal, precision: 10, scale: 2, default: 0
    change_column :client_table_prices, :margin_lucre,                      :decimal, precision: 10, scale: 2, default: 0  
  end

end