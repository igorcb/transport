class AddClientTablePriceToDirectCharges < ActiveRecord::Migration[5.0]
  def change
    add_column    :direct_charges, :billing_client_id, :integer, index: true
    add_reference :direct_charges, :stretch_route, index: true
    add_reference :direct_charges, :type_service, index: true
    add_reference :direct_charges, :client_table_price, index: true
  end
end
