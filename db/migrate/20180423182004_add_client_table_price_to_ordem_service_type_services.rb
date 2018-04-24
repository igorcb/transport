class AddClientTablePriceToOrdemServiceTypeServices < ActiveRecord::Migration
  def change
    add_reference :ordem_service_type_services, :client_table_price, index: true
  end
end
