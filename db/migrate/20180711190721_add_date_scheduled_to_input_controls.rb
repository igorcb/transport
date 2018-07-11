class AddDateScheduledToInputControls < ActiveRecord::Migration
  def change
    add_column :input_controls, :date_scheduled, :date
    add_column :input_controls, :time_scheduled, :time
    add_column :input_controls, :motive_scheduled, :text
  end
end
