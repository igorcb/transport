class AddTeamAndDockToInputControls < ActiveRecord::Migration
  def change
    add_column :input_controls, :team, :integer
    add_column :input_controls, :dock, :integer
  end
end
