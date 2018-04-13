class AddClientTablePriceToOrdemServices < ActiveRecord::Migration
  def change
    add_reference :ordem_services, :client_table_prince, index: true
  end
end
