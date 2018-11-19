class AddTeamToBoarding < ActiveRecord::Migration[5.0]
  def change
    add_column :boardings, :team, :integer
    add_column :boardings, :hangar, :integer
    add_column :boardings, :dock, :integer
    add_column :boardings, :start_time_boarding, :datetime
    add_column :boardings, :finish_time_boarding, :datetime
    add_reference :boardings, :started_user, foreign_key: {to_table: :users }
    add_reference :boardings, :confirmed_user, foreign_key: {to_table: :users }    
  end
end
