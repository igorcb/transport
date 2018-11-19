class AddStretchRoutesToInputControls < ActiveRecord::Migration[5.0]
  def change
    add_reference :input_controls, :stretch_route, index: true
  end
end
