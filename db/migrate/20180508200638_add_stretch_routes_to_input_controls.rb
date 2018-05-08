class AddStretchRoutesToInputControls < ActiveRecord::Migration
  def change
    add_reference :input_controls, :stretch_route, index: true
  end
end
