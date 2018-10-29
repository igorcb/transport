class AddTeamAndDockToInputControls < ActiveRecord::Migration[5.0]
  def change
    add_column :input_controls, :team, :integer
    add_column :input_controls, :dock, :integer
  end
end
