class AddHangarToInputControls < ActiveRecord::Migration
  def change
    add_column :input_controls, :hangar, :integer
  end
end
