class AddPlaceHorseToInputControls < ActiveRecord::Migration
  def change
    add_column :input_controls, :place_horse, :string
  end
end
