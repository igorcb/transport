class AddClientTablePriceToOrdemServiceTypeServices < ActiveRecord::Migration[5.0]
  def change
    add_reference :ordem_service_type_services, :client_table_price, index: true
  end
end
