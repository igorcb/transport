class AddUserReceivedToInputControls < ActiveRecord::Migration
  def change
    add_column :input_controls, :received_user_id, :integer, index: true
  end
end
