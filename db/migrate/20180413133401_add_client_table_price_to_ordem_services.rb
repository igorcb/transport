class AddClientTablePriceToOrdemServices < ActiveRecord::Migration[5.0]
  def change
    add_reference :ordem_services, :client_table_prince, index: true
  end
end
