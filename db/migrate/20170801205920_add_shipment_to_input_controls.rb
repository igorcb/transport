class AddShipmentToInputControls < ActiveRecord::Migration
  def change
    add_column :input_controls, :shipment, :string, limit: 30
  end
end
