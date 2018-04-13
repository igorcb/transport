json.array!(@client_table_prices) do |client_table_price|
  json.extract! client_table_price, :id, :client_id, :type_service_id, :freight_weight, :freight_value, :freight_volume, :freight_dispatch, :freight_toll, :freight_type_gris, :freight_gris, :freight_type_trt, :freight_trt, :minimum_total_freight, :minimum_weiht, :minimum_value, :minimum_gris, :minimum_trt, :minimum_weight_kg, :collection_delivery_incidence, :collection_delivery_ad_icms_value_frete, :collection_delivery_ad_value_minimum, :collection_delivery_icms_taxpayer, :collection_delivery_non_taxpayer, :use_aliquot_consumer_last, :validity_status, :validity_start, :validity_end, :secure_rate, :secure_rate_filch, :secure_rate_aggravated
  json.url client_table_price_url(client_table_price, format: :json)
end
