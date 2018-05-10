class AddTypeServicesToInputControls < ActiveRecord::Migration
  def change
    add_reference :input_controls, :type_service, index: true
  end
end
