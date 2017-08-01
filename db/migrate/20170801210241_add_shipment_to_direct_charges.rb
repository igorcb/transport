class AddShipmentToDirectCharges < ActiveRecord::Migration
  def change
    add_column :direct_charges, :shipment, :string, limit: 30
  end
end
