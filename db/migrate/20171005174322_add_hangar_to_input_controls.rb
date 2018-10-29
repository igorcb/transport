class AddHangarToInputControls < ActiveRecord::Migration[5.0]
  def change
    add_column :input_controls, :hangar, :integer
  end
end
