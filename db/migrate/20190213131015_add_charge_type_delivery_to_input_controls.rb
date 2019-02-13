class AddChargeTypeDeliveryToInputControls < ActiveRecord::Migration[5.1]
  def change
    add_column :input_controls, :charge_type_delivery, :integer
  end
end
