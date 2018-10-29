class AddShipmentToDirectCharges < ActiveRecord::Migration[5.0]
  def change
    add_column :direct_charges, :shipment, :string, limit: 30
  end
end
