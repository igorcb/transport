# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ordem_service_table_price do
    ordem_service nil
    type_service nil
    stretch_route nil
    client_table_price ""
    iss_tax "9.99"
    iss_value "9.99"
    margin_lucre_tax "9.99"
    margin_lucre_value "9.99"
  end
end
