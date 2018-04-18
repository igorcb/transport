class OrdemServiceTablePrice < ActiveRecord::Base
  belongs_to :ordem_service
  belongs_to :type_service
  belongs_to :stretch_route
  belongs_to :client_table_price
  belongs_to :ordem_service_type_service
end
