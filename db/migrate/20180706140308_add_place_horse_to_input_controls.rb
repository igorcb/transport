class AddPlaceHorseToInputControls < ActiveRecord::Migration[5.0]
  def change
    add_column :input_controls, :place_horse, :string
  end
end
