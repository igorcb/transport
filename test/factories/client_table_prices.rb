# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client_table_price do
    client nil
    type_service nil
    freight_weight "MyString"
    freight_value "MyString"
    freight_volume "MyString"
    freight_dispatch "MyString"
    freight_toll "9.99"
    freight_type_gris 1
    freight_gris "9.99"
    freight_type_trt 1
    freight_trt "9.99"
    minimum_total_freight "MyString"
    minimum_weiht "MyString"
    minimum_value "MyString"
    minimum_gris "MyString"
    minimum_trt "MyString"
    minimum_weight_kg "9.99"
    collection_delivery_incidence 1
    collection_delivery_ad_icms_value_frete 1
    collection_delivery_ad_value_minimum 1
    collection_delivery_icms_taxpayer "MyString"
    collection_delivery_non_taxpayer "9.99"
    use_aliquot_consumer_last 1
    validity_status 1
    validity_start "MyString"
    validity_end "2018-04-12"
    secure_rate "MyString"
    secure_rate_filch "MyString"
    secure_rate_aggravated "9.99"
  end
end
