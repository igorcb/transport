class AddTypeServicesToInputControls < ActiveRecord::Migration[5.0]
  def change
    add_reference :input_controls, :type_service, index: true
  end
end
