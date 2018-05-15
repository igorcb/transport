class ChangeCollectionDeliveryAdIcmsValueFreteToClientTablePrices < ActiveRecord::Migration
  def self.up
    change_column :client_table_prices, :collection_delivery_ad_icms_value_frete, 'integer USING CAST(collection_delivery_ad_icms_value_frete AS integer)'  
    change_column :client_table_prices, :collection_delivery_ad_value_minimum, 'integer USING CAST(collection_delivery_ad_value_minimum AS integer)'  
  end

  def self.down
    change_column :client_table_prices, :collection_delivery_ad_icms_value_frete, 'boolean USING CAST(collection_delivery_ad_icms_value_frete AS boolean)'  
    change_column :client_table_prices, :collection_delivery_ad_value_minimum, 'boolean USING CAST(collection_delivery_ad_value_minimum AS boolean)'  
  end

end


