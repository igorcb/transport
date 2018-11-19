class AddPlaceConfirmedToInputControls < ActiveRecord::Migration[5.0]
  def change
    add_column :input_controls, :place_confirmed, :string
    add_column :input_controls, :start_time_discharge, :datetime
    add_column :input_controls, :finish_time_discharge, :datetime
    add_reference :input_controls, :started_user, foreign_key: {to_table: :users }
  end
end
