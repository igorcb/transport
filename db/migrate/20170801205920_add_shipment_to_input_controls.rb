class AddShipmentToInputControls < ActiveRecord::Migration[5.0]
  def change
    add_column :input_controls, :shipment, :string, limit: 30
  end
end
